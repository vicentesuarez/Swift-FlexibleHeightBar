//
//  SquareCashFlexibleHeightBar.swift
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

class SquareCashFlexibleHeightBar: FlexibleHeightBar {
    
    private struct Constraints {
        static let maximumBarHeight: CGFloat = 200.0
        static let minimumBarHeight: CGFloat = 65.0
    }
    
    // MARK: - Properties -
    
    private var closeButtonPressedClosure: (()->())?
    
    // MARK: - IBOutlets -
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    func configurebar(viewWidth: CGFloat, closeButtonAction: (()->())) {
        frame = CGRectMake(0, 0, viewWidth, 100.0)
        
        // Configure bar appearance
        maximumBarHeight = Constraints.maximumBarHeight
        minimumBarHeight = Constraints.minimumBarHeight
        
        configureProfileImage()
        configureNameLabel()
        configureCloseButton()
        
        behaviorDefiner = SquareCashBarBehaviorDefiner()
        closeButtonPressedClosure = closeButtonAction
    }
    
    private func configureProfileImage() {
        
        let initialProfileImageViewLayoutAttributes = FlexibleHeightBarSubviewLayoutAttributes()
        initialProfileImageViewLayoutAttributes.size = CGSizeMake(70.0, 70.0)
        initialProfileImageViewLayoutAttributes.center = CGPointMake(frame.size.width / 2.0, maximumBarHeight - 110.0)
        addLayoutAttributes(initialProfileImageViewLayoutAttributes, forSubview: profileImageView, forProgress: 0.0)
        
        let midwayProfileImageViewLayoutAttributes = FlexibleHeightBarSubviewLayoutAttributes(layoutAttributes: initialProfileImageViewLayoutAttributes)
        midwayProfileImageViewLayoutAttributes.center = CGPointMake(frame.size.width / 2.0, (maximumBarHeight - minimumBarHeight) * 0.8 + minimumBarHeight - 110.0)
        addLayoutAttributes(midwayProfileImageViewLayoutAttributes, forSubview: profileImageView, forProgress: 0.2)
        
        let finalProfileImageViewLayoutAttributes = FlexibleHeightBarSubviewLayoutAttributes(layoutAttributes: midwayProfileImageViewLayoutAttributes)
        finalProfileImageViewLayoutAttributes.center = CGPointMake(frame.size.width / 2.0, (maximumBarHeight - minimumBarHeight) * 0.64 + minimumBarHeight - 110.0)
        finalProfileImageViewLayoutAttributes.transform = CGAffineTransformMakeScale(0.5, 0.5)
        finalProfileImageViewLayoutAttributes.alpha = 0.0
        addLayoutAttributes(finalProfileImageViewLayoutAttributes, forSubview: profileImageView, forProgress: 0.5)
    }
    
    private func configureNameLabel() {
        
        let initialLabelLayoutAttributes = FlexibleHeightBarSubviewLayoutAttributes()
        initialLabelLayoutAttributes.size = nameLabel.sizeThatFits(CGSizeZero)
        initialLabelLayoutAttributes.center = CGPointMake(frame.size.width / 2.0, maximumBarHeight - 50.0)
        addLayoutAttributes(initialLabelLayoutAttributes, forSubview: nameLabel, forProgress: 0.0)
        
        let midwayNameLabelLayoutAttributes = FlexibleHeightBarSubviewLayoutAttributes(layoutAttributes: initialLabelLayoutAttributes)
        midwayNameLabelLayoutAttributes.center = CGPointMake(frame.size.width / 2.0, (maximumBarHeight - minimumBarHeight) * 0.4 + minimumBarHeight - 50.0)
        addLayoutAttributes(midwayNameLabelLayoutAttributes, forSubview: nameLabel, forProgress: 0.6)
        
        let finalNameLabelLayoutAttributes = FlexibleHeightBarSubviewLayoutAttributes(layoutAttributes: midwayNameLabelLayoutAttributes)
        finalNameLabelLayoutAttributes.center = CGPointMake(frame.size.width / 2.0, minimumBarHeight - 25.0)
        addLayoutAttributes(finalNameLabelLayoutAttributes, forSubview: nameLabel, forProgress: 1.0)
    }
    
    private func configureCloseButton() {
        closeButton.frame = CGRectMake(frame.size.width - 40.0, 25.0, 30.0, 30.0)
    }
    
    // MARK: - IBAction -
    
    @IBAction func pressedCloseButton(sender: AnyObject) {
        closeButtonPressedClosure?()
    }
    
}
