//
//  SquareCashStyleViewController.swift
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

class SquareCashStyleViewController: ViewController {
    
    // MARK: - Constants -
    
    struct Identifier {
        static let SquareCashFlexibleHeightBar = "SquareCashFlexibleHeightBar"
        static let UnwindSquareCash = "UnwindSquareCash"
    }
    
    // MARK: - Properties -
    
    let dataSourceHandler = TableViewDataSourceHandler()
    let delegateHandler = TableViewDelegateHandler()
    
    var myCustomBar: SquareCashFlexibleHeightBar {
        get {
            if let customBar = _myCustomBar {
                return customBar
            }
            
            _myCustomBar = NSBundle.mainBundle().loadNibNamed(Identifier.SquareCashFlexibleHeightBar, owner: nil, options: nil)?.last as? SquareCashFlexibleHeightBar
            _myCustomBar?.closeButtonPressedClosure = {
                self.performSegueWithIdentifier(Identifier.UnwindSquareCash, sender: nil)
            }
            
            return _myCustomBar!
        }
    }
    var _myCustomBar: SquareCashFlexibleHeightBar?
    
    // MARK: - IBOutlet -
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View controller -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the table view
        tableView.dataSource = dataSourceHandler
        tableView.delegate = delegateHandler
        delegateHandler.otherDelegate = myCustomBar.behaviorDefiner
        
        view.addSubview(myCustomBar)
        configureCustomBarConstraints()
        
        tableView.contentInset = UIEdgeInsetsMake(myCustomBar.maximumBarHeight, 0.0, 0.0, 0.0)
    }
    
    func configureCustomBarConstraints() {
        myCustomBar.translatesAutoresizingMaskIntoConstraints = false
        let viewsDictionary = ["view": view, "myCustomBar": myCustomBar]
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[myCustomBar]-0-|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: viewsDictionary)
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[myCustomBar(\(myCustomBar.maximumBarHeight))]", options: NSLayoutFormatOptions.AlignAllTop, metrics: nil, views: viewsDictionary)
        
        view.addConstraints(horizontalConstraints)
        view.addConstraints(verticalConstraints)
        myCustomBar.heightConstraint = verticalConstraints.last
    }
}
