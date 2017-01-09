//
//  SquareCashFlexibleHeightBar.swift
//  FlexibleHeightBarDemo
//
//  Created by Vicente Suarez on 1/8/17.
//  Copyright © 2017 Vicente Suarez. All rights reserved.
//

import UIKit
import FlexibleHeightBar

class SquareCashFlexibleHeightBar: FlexibleHeightBar {
    
    private struct Constraints {
        static let maximumBarHeight: CGFloat = 200.0
        static let minimumBarHeight: CGFloat = 60.0
    }
    
    // MARK: - Properties -
    
    var closeButtonPressedClosure: (()->())?
    
    // MARK: - IBOutlets -
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet var profileImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet var profileImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet var nameLabelBottomConstraint: NSLayoutConstraint!
    
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
}
