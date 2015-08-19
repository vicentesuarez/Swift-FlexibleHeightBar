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

/**
    This extension of CALayer allows setting the borderColor and shodowColor of the layer from interface builder.
*/
extension CALayer {
    
    /**
        The color of the layer’s border. Animatable.
        The default value of this property is an opaque black color.
        The value of this property is retained using the Core Foundation retain/release semantics. This behavior occurs despite the fact that the property declaration appears to use the default assign semantics for object retention.
    */
    var borderUIColor: UIColor {
        set (newBorderColor) {
            self.borderColor = newBorderColor.CGColor
        }
        get {
            return UIColor(CGColor: self.borderColor!)
        }
    }
    
    /**
        The color of the layer’s shadow. Animatable.
        The default value of this property is an opaque black color.
        The value of this property is retained using the Core Foundation retain/release semantics. This behavior occurs despite the fact that the property declaration appears to use the default assign semantics for object retention.
    */
    var shadowUIColor: UIColor {
        set (newShadowColor) {
            self.shadowColor = newShadowColor.CGColor
        }
        get {
            return UIColor(CGColor: self.shadowColor!)
        }
    }
}