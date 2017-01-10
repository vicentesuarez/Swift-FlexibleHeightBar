//
//  SquareCashBarBehaviorDefiner.swift
//  FlexibleHeightBar
//
//  Created by Vicente Suarez on 1/8/17.
//  Copyright © 2017 Vicente Suarez. All rights reserved.
//

import UIKit

public class SquareCashBarBehaviorDefiner: FlexibleHeightBarBehaviorDefiner {
    
    // MARK: - Initialization -
    
    public override init() {
        super.init()
        
        addSnappingPositionProgress(0.0, _forProgressRangeStart: 0.0, end: 0.5)
        addSnappingPositionProgress(1.0, _forProgressRangeStart: 0.5, end: 1.0)
        elasticMaximumHeightAtTop = true
    }
    
    // MARK: - UIScrollViewDelegate methods -
    
    override public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        
        if let flexHeightBar = flexibleHeightBar, !currentlySnapping {
            let progress = (scrollView.contentOffset.y + scrollView.contentInset.top) / (flexHeightBar.maximumBarHeight - flexHeightBar.minimumBarHeight)
            flexHeightBar.progress = progress
            flexHeightBar.setNeedsLayout()
        }
    }
}
