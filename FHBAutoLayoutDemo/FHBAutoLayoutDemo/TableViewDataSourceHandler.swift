//
//  tableViewDataSourceHandler.swift
//  FlexibleHeightBarDemo
//
//  Created by Vicente Suarez on 8/12/15.
//  Copyright © 2015 Vicente Suarez. All rights reserved.
//

import UIKit

class TableViewDataSourceHandler: NSObject, UITableViewDataSource {
    
    // MARK: - Constants
    
    private struct Constants {
        static let cellID = "Cell"
        static let numberOfRows = 20
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.numberOfRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(Constants.cellID)!
    }
}
