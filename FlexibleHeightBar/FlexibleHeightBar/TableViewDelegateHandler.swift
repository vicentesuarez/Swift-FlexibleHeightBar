//
//  TableViewDelegateHandler.swift
//  FlexibleHeightBarDemo
//
//  Created by Vicente Suarez on 8/12/15.
//  Copyright © 2015 Vicente Suarez. All rights reserved.
//

import UIKit

open class TableViewDelegateHandler: NSObject, UITableViewDelegate {
    
    // MARK: - Properties -
    
    /// Second delegate object that responds to scrollViewDelegate events
    public var otherDelegate: UIScrollViewDelegate?
    
    // MARK: - Scrollview Delegate -
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        otherDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        otherDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        otherDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        otherDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
}
