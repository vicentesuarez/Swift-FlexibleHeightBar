//
//  FacebookBarBehaviorDefiner.swift
//  FlexibleHeightBarDemo
//
//  Created by Vicente Suarez on 1/8/17.
//  Copyright © 2017 Vicente Suarez. All rights reserved.
//

import UIKit

public class FacebookBarBehaviorDefiner: FlexibleHeightBarBehaviorDefiner {
    // MARK: - Properties -
    
    private var thresholdFromTop: CGFloat {
        get {
            return _thresholdFromTop
        }
        set (newThresholdFromTop) {
            _thresholdFromTop = fmax(newThresholdFromTop, 0.0)
        }
    }
    private var _thresholdFromTop: CGFloat = 0.0
    
    private var thresholdNegativeDirection: CGFloat {
        get {
            return _thresholdNegativeDirection
        }
        set (newThresholdNegativeDirection) {
            _thresholdNegativeDirection = fmax(newThresholdNegativeDirection, 0.0)
        }
    }
    private var _thresholdNegativeDirection: CGFloat = 0.0
    
    private var thresholdPositiveDirection: CGFloat {
        get {
            return _thresholdPositiveDirection
        }
        set (newThresholdPositiveDirection) {
            _thresholdPositiveDirection = fmax(newThresholdPositiveDirection, 0.0)
        }
    }
    private var _thresholdPositiveDirection: CGFloat = 0.0
    
    private var previousYOffset: CGFloat = 0.0
    private var previousProgress: CGFloat = 0.0
    
    // MARK: - Initialization -
    
    public override init() {
        super.init()
        
        addSnappingPositionProgress(0.0, _forProgressRangeStart: 0.0, end: 40.0/(105.0 - 20.0))
        addSnappingPositionProgress(1.0, _forProgressRangeStart: 40.0/(105.0 - 20.0), end: 1.0)
        thresholdNegativeDirection = 140.0
    }
    
    // MARK: - Apply progress tracking -
    
    private func applyFromTopProgressTrackingThreshold() {
        previousYOffset += thresholdFromTop
    }
    
    private func applyNegativeDirectionProgressTrackingThreshold() {
        if flexibleHeightBar?.progress == 1.0 {
            previousYOffset -= thresholdNegativeDirection
        }
    }
    
    private func applyPositiveDirectionProgressTrackingThreshold() {
        if flexibleHeightBar?.progress == 0.0 {
            previousYOffset += thresholdPositiveDirection
        }
    }
    
    // MARK: - Scrollview delegate methods -
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let flexHeightBar = flexibleHeightBar {
            
            let scrollViewViewportHeight = scrollView.bounds.maxY - scrollView.bounds.minY
            
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
    
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
