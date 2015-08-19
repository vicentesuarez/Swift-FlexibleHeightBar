//
//  FacebookBarBehaviorDefiner.swift
//  FlexibleHeightBarDemo
//
//  Modified and converted to swift by Vicente Suarez on 8/11/15.
//  Copyright © 2015 Vicente Suarez. All rights reserved.
//

/*
    Copyright (c) 2015, Bryan Keller. All rights reserved.
    Licensed under the MIT license <http://opensource.org/licenses/MIT>

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portionsof the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import UIKit

class FacebookBarBehaviorDefiner: FlexibleHeightBarBehaviorDefiner {
    
    // MARK: - Properties -
    
    var thresholdFromTop: CGFloat {
        get {
            return _thresholdFromTop
        }
        set (newThresholdFromTop) {
            _thresholdFromTop = fmax(newThresholdFromTop, 0.0)
        }
    }
    var _thresholdFromTop: CGFloat = 0.0
    
    var thresholdNegativeDirection: CGFloat {
        get {
            return _thresholdNegativeDirection
        }
        set (newThresholdNegativeDirection) {
            _thresholdNegativeDirection = fmax(newThresholdNegativeDirection, 0.0)
        }
    }
    var _thresholdNegativeDirection: CGFloat = 0.0
    
    var thresholdPositiveDirection: CGFloat {
        get {
            return _thresholdPositiveDirection
        }
        set (newThresholdPositiveDirection) {
            _thresholdPositiveDirection = fmax(newThresholdPositiveDirection, 0.0)
        }
    }
    var _thresholdPositiveDirection: CGFloat = 0.0
    
    private var previousYOffset: CGFloat = 0.0
    private var previousProgress: CGFloat = 0.0
    
    // MARK: - Initialization -
    
    override init() {
        super.init()
        
        addSnappingPositionProgress(0.0, _forProgressRangeStart: 0.0, end: 40.0/(105.0 - 20.0))
        addSnappingPositionProgress(1.0, _forProgressRangeStart: 40.0/(105.0 - 20.0), end: 1.0)
        thresholdNegativeDirection = 140.0
    }
    
    // MARK: - Apply progress tracking -
    
    func applyFromTopProgressTrackingThreshold() {
        previousYOffset += thresholdFromTop
    }
    
    func applyNegativeDirectionProgressTrackingThreshold() {
        if flexibleHeightBar?.progress == 1.0 {
            previousYOffset -= thresholdNegativeDirection
        }
    }
    
    func applyPositiveDirectionProgressTrackingThreshold() {
        if flexibleHeightBar?.progress == 0.0 {
            previousYOffset += thresholdPositiveDirection
        }
    }
    
    // MARK: - Scrollview delegate methods -
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if let flexHeightBar = flexibleHeightBar {
            
            let scrollViewViewportHeight = CGRectGetMaxY(scrollView.bounds) - CGRectGetMinY(scrollView.bounds)
            
            if (scrollView.contentOffset.y + scrollView.contentInset.top) >= 0.0 && scrollView.contentOffset.y <= (scrollView.contentSize.height - scrollViewViewportHeight) {
                previousYOffset = scrollView.contentOffset.y
                previousProgress = flexHeightBar.progress
                
                // Apply top threshold
                if (scrollView.contentOffset.y + scrollView.contentInset.top) == 0.0 {
                    applyFromTopProgressTrackingThreshold()
                } else {
                    // Edge case (not true) - user is scrolling to the top but there isn't enough runway left to pass the threshold
                    if (scrollView.contentOffset.y + scrollView.contentInset.top) > (thresholdNegativeDirection + (flexHeightBar.maximumBarHeight - flexHeightBar.minimumBarHeight)) {
                        applyNegativeDirectionProgressTrackingThreshold()
                    }
                    
                    // Edge case (not true) - user is scrolling to the bottom but there isn't enough runway left to pass the threshold
                    if scrollView.contentOffset.y < (scrollView.contentSize.height - scrollViewViewportHeight - thresholdPositiveDirection) {
                        applyPositiveDirectionProgressTrackingThreshold()
                    }
                }
                // Edge case - user starts to scroll while the scroll view is stretched above the top
            } else if (scrollView.contentOffset.y + scrollView.contentInset.top) < 0.0 {
                previousYOffset = -scrollView.contentInset.top
                previousProgress = 0.0
                if thresholdFromTop != 0.0 {
                    applyFromTopProgressTrackingThreshold()
                } else {
                    applyNegativeDirectionProgressTrackingThreshold()
                    applyPositiveDirectionProgressTrackingThreshold()
                }
                // Edge case - user starts to scroll while the scroll view is stretched below the bottom
            } else if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollViewViewportHeight) {
                if scrollView.contentSize.height > scrollViewViewportHeight {
                    previousYOffset = scrollView.contentSize.height - scrollViewViewportHeight
                    previousProgress = 1.0
                    
                    applyNegativeDirectionProgressTrackingThreshold()
                    applyPositiveDirectionProgressTrackingThreshold()
                }
            }
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        if let flexHeightBar = flexibleHeightBar {
            
            if !currentlySnapping {
                let deltaYOffset = scrollView.contentOffset.y - previousYOffset
                let deltaProgress = deltaYOffset / (flexHeightBar.maximumBarHeight - flexHeightBar.minimumBarHeight)
                
                flexHeightBar.progress = previousProgress + deltaProgress
                flexHeightBar.setNeedsLayout()
            }
        }
    }
}