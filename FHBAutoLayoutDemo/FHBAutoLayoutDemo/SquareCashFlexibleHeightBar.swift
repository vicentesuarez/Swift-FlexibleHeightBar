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
        static let minimumBarHeight: CGFloat = 60.0
    }
    
    // MARK: - Properties -
    
    var closeButtonPressedClosure: (()->())?
    
    // MARK: - IBOutlets -
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var profileImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLabelBottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configurebar()
    }
    
    func configurebar() {
        
        // Configure bar appearance
        maximumBarHeight = Constraints.maximumBarHeight
        minimumBarHeight = Constraints.minimumBarHeight
        
        configureProfileImage()
        configureNameLabel()
        
        behaviorDefiner = SquareCashBarBehaviorDefiner()
    }
    
    private func configureProfileImage() {
        
        let initialProfileImageSizeConstraintConstant = profileImageWidthConstraint.constant
        let finalProfileImageSizeConstraintConstant: CGFloat = 0.0
        
        addLayoutConstraintConstant(initialProfileImageSizeConstraintConstant, forContraint: profileImageWidthConstraint, forProgress: 0.2)
        addLayoutConstraintConstant(initialProfileImageSizeConstraintConstant, forContraint: profileImageHeightConstraint, forProgress: 0.2)
        addLayoutConstraintConstant(finalProfileImageSizeConstraintConstant, forContraint: profileImageWidthConstraint, forProgress: 0.5)
        addLayoutConstraintConstant(finalProfileImageSizeConstraintConstant, forContraint: profileImageHeightConstraint, forProgress: 0.5)
        
        let initialProfileImageViewLayoutAttributes = FlexibleHeightBarSubviewLayoutAttributes()
        initialProfileImageViewLayoutAttributes.cornerRadius = 36.0
        let finalProfileImageViewLayoutAttributes = FlexibleHeightBarSubviewLayoutAttributes(layoutAttributes: initialProfileImageViewLayoutAttributes)
        finalProfileImageViewLayoutAttributes.cornerRadius = 0.0
        finalProfileImageViewLayoutAttributes.alpha = 0.0
        
        addLayoutAttributes(initialProfileImageViewLayoutAttributes, forSubview: profileImageView, forProgress: 0.2)
        addLayoutAttributes(finalProfileImageViewLayoutAttributes, forSubview: profileImageView, forProgress: 0.5)
    }
    
    private func configureNameLabel() {
        
        let initialNameLabelBottomConstraintConstant = nameLabelBottomConstraint.constant
        let finalNameLabelBottomConstraintConstant = initialNameLabelBottomConstraintConstant - 30.0
        
        addLayoutConstraintConstant(initialNameLabelBottomConstraintConstant, forContraint: nameLabelBottomConstraint, forProgress: 0.6)
        addLayoutConstraintConstant(finalNameLabelBottomConstraintConstant, forContraint: nameLabelBottomConstraint, forProgress: 1.0)
    }
    
    // MARK: - IBAction -
    
    @IBAction func pressedCloseButton(sender: AnyObject) {
        closeButtonPressedClosure?()
    }
    
}
