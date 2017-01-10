//
//  FacebookStyleViewController.swift
//  FlexibleHeightBarDemo
//
//  Created by Vicente Suarez on 1/8/17.
//  Copyright © 2017 Vicente Suarez. All rights reserved.
//

import UIKit
import FlexibleHeightBar

class FacebookStyleViewController: UIViewController {
    
    let delegateHandler = TableViewDelegateHandler()
    let dataSourceHandler = TableViewDataSourceHandler()
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var customBar: FacebookFlexibleHeightBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSourceHandler
        tableView.delegate = delegateHandler
        delegateHandler.otherDelegate = customBar.behaviorDefiner
        customBar.heightConstraint = heightConstraint
        tableView.contentInset = UIEdgeInsetsMake(customBar.maximumBarHeight, 0.0, 0.0, 0.0)
    }
}
