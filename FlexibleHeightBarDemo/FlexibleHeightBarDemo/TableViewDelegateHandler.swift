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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        otherDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        otherDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        otherDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        otherDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
}
