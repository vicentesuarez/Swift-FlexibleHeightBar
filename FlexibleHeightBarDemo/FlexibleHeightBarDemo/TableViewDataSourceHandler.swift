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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath)
    }
}
