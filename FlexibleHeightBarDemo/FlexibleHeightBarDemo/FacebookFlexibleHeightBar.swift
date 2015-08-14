//
//  FacebookFlexibleHeightBar.swift
//  FlexibleHeightBarDemo
//
//  Created by Vicente Suarez on 8/11/15.
//  Copyright © 2015 Vicente Suarez. All rights reserved.
//

import UIKit

class FacebookFlexibleHeightBar: FlexibleHeightBar {
    
    private struct Constraints {
        static let maximumBarHeight: CGFloat = 105.0
        static let minimumBarHeight: CGFloat = 20.0
    }
    
    // MARK: - Properties -
    
    private var closeButtonPressedClosure: (()->())?
    
    // MARK: - IBOutlets -
    
    @IBOutlet weak var blueBarView: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var whiteBarView: UIView!
    @IBOutlet weak var bottomBorderView: UIView!
    @IBOutlet weak var leftVerticalDividerView: UIView!
    @IBOutlet weak var rightVerticalDividerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    // MARK: - Setup after initialization -
    
    func configureBar(viewWidth: CGFloat, closeButtonAction: (()->())) {
        
        // Configure bar appearence
        frame = CGRectMake(0, 0, viewWidth, 100.0)
        maximumBarHeight = Constraints.maximumBarHeight
        minimumBarHeight = Constraints.minimumBarHeight
        
        configureBlueBar()
        configureSearchField()
        configureCloseButton()
        configureWhiteBar()
        
        // Configure bar behavior
        behaviorDefiner = FacebookBarBehaviorDefiner()
        closeButtonPressedClosure = closeButtonAction
    }
    
    private func configureBlueBar() {
        
        let initialBlueBarLayoutAttributes = FlexibleHeightBarSubviewLayoutAttributes()
        initialBlueBarLayoutAttributes.frame = CGRectMake(0.0, 25.0, frame.size.width, 40.0)
        
        let finalBlueBarLayoutAttributes = FlexibleHeightBarSubviewLayoutAttributes(layoutAttributes: initialBlueBarLayoutAttributes)
        finalBlueBarLayoutAttributes.transform = CGAffineTransformMakeTranslation(0.0, -40.0)
        
        addLayoutAttributes(initialBlueBarLayoutAttributes, forSubview: blueBarView, forProgress: 0.0)
        addLayoutAttributes(initialBlueBarLayoutAttributes, forSubview: blueBarView, forProgress: 40.0 / (105.0 - 20.0))
        addLayoutAttributes(finalBlueBarLayoutAttributes, forSubview: blueBarView, forProgress: 1.0)
    }
    
    private func configureSearchField() {
        
        let initialSearchFieldLayoutAttributes = FlexibleHeightBarSubviewLayoutAttributes()
        initialSearchFieldLayoutAttributes.frame = CGRectMake(8.0, 0.0, frame.size.width * 0.85, blueBarView.frame.size.height - 8.0)
        
        let finalSearchFieldLayoutAttributes = FlexibleHeightBarSubviewLayoutAttributes(layoutAttributes: initialSearchFieldLayoutAttributes)
        finalSearchFieldLayoutAttributes.alpha = 0.0
        
        addLayoutAttributes(initialSearchFieldLayoutAttributes, forSubview: searchField, forProgress: 0.0)
        addLayoutAttributes(initialSearchFieldLayoutAttributes, forSubview: searchField, forProgress: 40.0 / (105.0 - 20.0))
        addLayoutAttributes(finalSearchFieldLayoutAttributes, forSubview: searchField, forProgress: 0.8)
        addLayoutAttributes(finalSearchFieldLayoutAttributes, forSubview: searchField, forProgress: 1.0)
    }
    
    private func configureCloseButton() {
        
        let initialCloseButtonLayoutAttributes = FlexibleHeightBarSubviewLayoutAttributes()
        initialCloseButtonLayoutAttributes.frame = CGRectMake(frame.size.width - 35.0, 1.5, 30.0, 30.0)
//        initialCloseButtonLayoutAttributes.zIndex = 1024
        
        let finalCloseButtonLayoutAttributes = FlexibleHeightBarSubviewLayoutAttributes(layoutAttributes: initialCloseButtonLayoutAttributes)
        finalCloseButtonLayoutAttributes.alpha = 0.0
        
        addLayoutAttributes(initialCloseButtonLayoutAttributes, forSubview: closeButton, forProgress: 0.0)
        addLayoutAttributes(initialCloseButtonLayoutAttributes, forSubview: closeButton, forProgress: 40.0 / (105.0 - 20.0))
        addLayoutAttributes(finalCloseButtonLayoutAttributes, forSubview: closeButton, forProgress: 0.8)
        addLayoutAttributes(finalCloseButtonLayoutAttributes, forSubview: closeButton, forProgress: 1.0)
    }
    
    private func configureWhiteBar() {
        
        let initialWhiteBarLayoutAttributes = FlexibleHeightBarSubviewLayoutAttributes()
        initialWhiteBarLayoutAttributes.frame =  CGRectMake(0.0, 65.0, frame.size.width, 40.0)
        
        let finalWhiteBarLayoutAttributes = FlexibleHeightBarSubviewLayoutAttributes(layoutAttributes: initialWhiteBarLayoutAttributes)
        finalWhiteBarLayoutAttributes.transform = CGAffineTransformMakeTranslation(0.0, -40.0)
        
        addLayoutAttributes(initialWhiteBarLayoutAttributes, forSubview: whiteBarView, forProgress: 0.0)
        addLayoutAttributes(finalWhiteBarLayoutAttributes, forSubview: whiteBarView, forProgress: 40.0 / (105.0 - 20.0))
        
        configureWhiteBarSubviews(initialWhiteBarLayoutAttributes.size)
    }
    
    private func configureWhiteBarSubviews(size: CGSize) {
        
        bottomBorderView.frame = CGRectMake(0.0, size.height - 0.5, size.width, 0.5)
        leftVerticalDividerView.frame = CGRectMake(size.width * 0.334, size.height * 0.1, 0.5, size.height * 0.8)
        rightVerticalDividerView.frame = CGRectMake(size.width * 0.667, size.height * 0.1, 0.5, size.height * 0.8)
    }
    
    // MARK: - IBActions -
    
    @IBAction func pressedCloseButton(sender: AnyObject) {
        closeButtonPressedClosure?()
    }
}
