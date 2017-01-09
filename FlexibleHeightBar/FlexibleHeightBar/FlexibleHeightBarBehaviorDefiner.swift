//
//  FlexibleHeightBarBehaviorDefiner.swift
//  JokeMinder
//
//  Modified and converted to swift by Vicente Suarez on 7/31/15.
//  Copyright © 2015 Vicente Suarez. All rights reserved.
//

/*
Copyright (c) 2015, Bryan Keller. All rights reserved.
Licensed under the MIT license <http://opensource.org/licenses/MIT>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portionsof the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/


import UIKit

/**
    The FlexibleHeightBarBehaviorDefiner class is responsible for defining how its FlexibleHeightBar instance will behave. Often, this behavior is tightly coupled with scroll events (i.e. a UITableView scrolling to the top). Because of this close relationship between bar behavior and scroll events, behavior definers conform to UIScrollViewDelegate. A behavior definer should set its bar's progress property to adjust the bar's height.
    The base class FlexibleHeightBarBehaviorDefiner does not attempt to adjust the bar's height based on scroll position, leaving it up to subclasses to implement custom bar behavior based on scrolling. The base class does, however, provide snapping behavior support. Snapping forces the bar to always snap to one of the defined snapping progress values.
*/
open class FlexibleHeightBarBehaviorDefiner: NSObject, UIScrollViewDelegate {
    
    /// The FlexibleHeightBar instance corresponding with the behavior definer.
    // weak
    public var flexibleHeightBar: FlexibleHeightBar?
    /// Determines whether snapping is enabled or not. Default value is YES.
    public var snappingEnabled = true
    /// Determines whether the bar is current snapping or not.
    public private(set) var currentlySnapping = false
    /// Determines whether the bar can stretch to larger sizes than it's maximumBarHeight. Default value is NO.
    public var elasticMaximumHeightAtTop = false
    private var snappingPositionsForProgressRanges = [NSValue: NSNumber]()
    
    private let snappingPositionAssertionMessage = "progressPercentRange sent to -addSnappingProgressPosition:forProgressPercentRange: intersects a progressPercentRange for an existing progressPosition."
    
    // MARK: - Snapping -
    
    /**
        Add a progress position that the bar will snap to whenever a user stops scrolling and the bar's current progress falls within the specified progress range.

        - Parameter progress: The progress position that the bar will snap to.
        - Parameter start: The start of the range of progress percents (between 0.0 and 1.0 inclusive) that will cause the bar to snap to the specified progressPosition.
        - Parameter end: The start of the range of progress percents (between 0.0 and 1.0 inclusive) that will cause the bar to snap to the specified progressPosition.
    */
    public func addSnappingPositionProgress(_ progress: CGFloat, _forProgressRangeStart start: CGFloat, end: CGFloat) {
        
        // Make sure start and end are between 0 and 1
        let newStart = fmax(fmin(start, 1.0), 0.0) * 100.0
        let newEnd = fmax(fmin(end, 1.0), 0.0) * 100.0
        let progressPercentRange = NSMakeRange(Int(newStart), Int(newEnd - newStart))
        
        for (key, _) in snappingPositionsForProgressRanges {
            let existingRange = key.rangeValue
            
            let noRangeConflict = (NSIntersectionRange(progressPercentRange, existingRange).length == 0)
            assert(noRangeConflict, self.snappingPositionAssertionMessage)
        }
        
        let progressPercentRangeValue = NSValue(range: progressPercentRange)
        let progressPositionValue = NSNumber(value: Double(progress))
        
        snappingPositionsForProgressRanges[progressPercentRangeValue] = progressPositionValue
    }
    
    /**
        Removes the progress position corresponding to the specified progress range.

        - Parameter start: The start of the range of progress percents (between 0.0 and 1.0 inclusive) that correspond with the progressPosition that is to be removed.
        - Parameter end: The end of the range of progress percents (between 0.0 and 1.0 inclusive) that correspond with the progressPosition that is to be removed.
    */
    public func removeSnappingPositionProgressForProgressRangeStart(start: CGFloat, end: CGFloat) {
        
        // Make sure start and end are between 0 and 1
        let newStart = fmax(fmin(start, 1.0), 0.0) * 100.0
        let newEnd = fmax(fmin(end, 1.0), 0.0) * 100.0
        let progressPercentRange = NSMakeRange(Int(newStart), Int(newEnd - newStart))
        
        let progressPercentRangeValue = NSValue(range: progressPercentRange)
        
        snappingPositionsForProgressRanges.removeValue(forKey: progressPercentRangeValue)
    }
    /**
        Snap to the specified progress position.
    
        - Parameter progress: The progress position that the bar will snap to.
        - Parameter scrollView: The UIScrollView whose offset will be adjusted during the snap.
    */
    public func snapToProgress(progress: CGFloat, scrollView: UIScrollView) {
        if let flexHeightBar = flexibleHeightBar {
            let deltaProgress = progress - flexHeightBar.progress
            let deltaYOffset = (flexHeightBar.maximumBarHeight - flexHeightBar.minimumBarHeight) * deltaProgress
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y + deltaYOffset)
            
            flexHeightBar.progress = progress
            flexHeightBar.setNeedsLayout()
            flexHeightBar.layoutIfNeeded()
            
            currentlySnapping = false
        }
    }
    /**
        Snap to the appropriate progress position based on the bar's current progress and the currently defined snapping position progresses.
    
        - Parameter scrollView: The UIScrollView whose offset will be adjusted during the snap.
    */
    public func snap(with scrollView: UIScrollView) {
        if let flexHeightBar = flexibleHeightBar {
            if !currentlySnapping && snappingEnabled && flexHeightBar.progress >= 0 {
                
                currentlySnapping = true
                var snapPosition = CGFloat(MAXFLOAT)
                
                for (key, object) in snappingPositionsForProgressRanges {
                    let existingRange = key.rangeValue
                    
                    let progressPercent = flexHeightBar.progress * 100.0
                    
                    if progressPercent >= CGFloat(existingRange.location) &&
                        progressPercent <= CGFloat(existingRange.location + existingRange.length) {
                        snapPosition = CGFloat(object)
                    }
                }
                
                if snapPosition != CGFloat(MAXFLOAT) {
                    
                    UIView.animate(withDuration: 0.15, animations: {
                        self.snapToProgress(progress: snapPosition, scrollView: scrollView)
                        }, completion: { flag in
                            self.currentlySnapping = false
                    })
                } else {
                    currentlySnapping = false
                }
            }
        }
    }
    
    // MARK: - Scroll View Delegate -
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        snap(with: scrollView)
    }
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            snap(with: scrollView)
        }
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let flexibleHeightBar = flexibleHeightBar {
            scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(flexibleHeightBar.bounds.height, scrollView.scrollIndicatorInsets.left, scrollView.scrollIndicatorInsets.bottom, scrollView.scrollIndicatorInsets.right)
        }
    }
}
