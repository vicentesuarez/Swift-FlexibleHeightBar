//
//  CALayer+XibConfiguration.swift
//  JokeMinder
//
//  Created by Vicente Suarez on 7/3/15.
//  Copyright (c) 2015 Vicente Suarez. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

extension CALayer {
    
    var borderUIColor: UIColor {
        set (newBorderColor) {
            self.borderColor = newBorderColor.CGColor
        }
        get {
            return UIColor(CGColor: self.borderColor!)
        }
    }
    
    var shadowUIColor: UIColor {
        set (newShadowColor) {
            self.shadowColor = newShadowColor.CGColor
        }
        get {
            return UIColor(CGColor: self.shadowColor!)
        }
    }
}