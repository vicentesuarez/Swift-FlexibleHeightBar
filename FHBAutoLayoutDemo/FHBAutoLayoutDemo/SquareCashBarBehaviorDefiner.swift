//
//  SquareCashBarBehaviorDefiner.swift
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

class SquareCashBarBehaviorDefiner: FlexibleHeightBarBehaviorDefiner {
    
    // MARK: - Initialization -
    
    override init() {
        super.init()
        
        addSnappingPositionProgress(0.0, _forProgressRangeStart: 0.0, end: 0.5)
        addSnappingPositionProgress(1.0, _forProgressRangeStart: 0.5, end: 1.0)
        elasticMaximumHeightAtTop = true
    }
    
    // MARK: - UIScrollViewDelegate methods -
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        
        if let flexHeightBar = flexibleHeightBar where !currentlySnapping {
            let progress = (scrollView.contentOffset.y + scrollView.contentInset.top) / (flexHeightBar.maximumBarHeight - flexHeightBar.minimumBarHeight)
            flexHeightBar.progress = progress
            flexHeightBar.setNeedsLayout()
        }
    }
}
