//
//  FacebookFlexibleHeightBar.swift
//  FlexibleHeightBarDemo
//
//  Created by Vicente Suarez on 1/8/17.
//  Copyright © 2017 Vicente Suarez. All rights reserved.
//

import UIKit
import FlexibleHeightBar

class FacebookFlexibleHeightBar: FlexibleHeightBar {

    private struct Constraints {
        static let maximumBarHeight: CGFloat = 100.0
        static let minimumBarHeight: CGFloat = 20.0
    }
    
    // MARK: - Properties -
    
    var closeButtonPressedClosure: (()->())?
    
    // MARK: - IBOutlets -
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var blueBarBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Setup after initialization -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureBar()
    }
    
    func configureBar() {
        
        // Configure bar appearence
        maximumBarHeight = Constraints.maximumBarHeight
        minimumBarHeight = Constraints.minimumBarHeight
        
        configureBlueBar()
        configureSearchField()
        configureCloseButton()
        
        // Configure bar behavior
        behaviorDefiner = FacebookBarBehaviorDefiner()
    }
    
    private func configureBlueBar() {
        
        let initialBlueBarBottomBarConstraintConstant = blueBarBottomConstraint.constant
        let finaBlueBarBottomBarConstraintConstant = initialBlueBarBottomBarConstraintConstant - 40.0
        
        addLayoutConstraintConstant(initialBlueBarBottomBarConstraintConstant, forContraint: blueBarBottomConstraint, forProgress: 0.0)
        addLayoutConstraintConstant(finaBlueBarBottomBarConstraintConstant, forContraint: blueBarBottomConstraint, forProgress: 0.5)
        addLayoutConstraintConstant(finaBlueBarBottomBarConstraintConstant, forContraint: blueBarBottomConstraint, forProgress: 1.0)
    }
    
    private func configureSearchField() {
        
        let initialSearchFieldLayoutAttributes = FlexibleHeightBarSubviewLayoutAttributes()
        let finalSearchFieldLayoutAttributes = FlexibleHeightBarSubviewLayoutAttributes(layoutAttributes: initialSearchFieldLayoutAttributes)
        finalSearchFieldLayoutAttributes.alpha = 0.0
        
        addLayoutAttributes(initialSearchFieldLayoutAttributes, forSubview: searchField, forProgress: 0.0)
        addLayoutAttributes(initialSearchFieldLayoutAttributes, forSubview: searchField, forProgress: 0.5)
        addLayoutAttributes(finalSearchFieldLayoutAttributes, forSubview: searchField, forProgress: 0.8)
        addLayoutAttributes(finalSearchFieldLayoutAttributes, forSubview: searchField, forProgress: 1.0)
    }
    
    private func configureCloseButton() {
        
        let initialCloseButtonLayoutAttributes = FlexibleHeightBarSubviewLayoutAttributes()
        let finalCloseButtonLayoutAttributes = FlexibleHeightBarSubviewLayoutAttributes(layoutAttributes: initialCloseButtonLayoutAttributes)
        finalCloseButtonLayoutAttributes.alpha = 0.0
        
        addLayoutAttributes(initialCloseButtonLayoutAttributes, forSubview: closeButton, forProgress: 0.0)
        addLayoutAttributes(initialCloseButtonLayoutAttributes, forSubview: closeButton, forProgress: 0.5)
        addLayoutAttributes(finalCloseButtonLayoutAttributes, forSubview: closeButton, forProgress: 0.8)
        addLayoutAttributes(finalCloseButtonLayoutAttributes, forSubview: closeButton, forProgress: 1.0)
    }
}
