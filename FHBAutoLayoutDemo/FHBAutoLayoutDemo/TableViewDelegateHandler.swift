//
//  TableViewDelegateHandler.swift
//  FlexibleHeightBarDemo
//
//  Created by Vicente Suarez on 8/12/15.
//  Copyright © 2015 Vicente Suarez. All rights reserved.
//

import UIKit

class TableViewDelegateHandler: NSObject, UITableViewDelegate {
    
    // MARK: - Properties -
    
    /// Second delegate object that responds to scrollViewDelegate events
    var otherDelegate: UIScrollViewDelegate?
    
    // MARK: - Scrollview Delegate -
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        otherDelegate?.scrollViewDidScroll?(scrollView)
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        otherDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        otherDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        otherDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
}
