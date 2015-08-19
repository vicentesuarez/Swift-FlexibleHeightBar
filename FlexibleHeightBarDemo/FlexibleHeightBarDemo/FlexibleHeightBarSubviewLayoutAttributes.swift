//
//  FlexibleHeightBarSubviewLayoutAttributes.swift
//  JokeMinder
//
//  Modified and converted to swift by Vicente Suarez on 7/31/15.
//  Copyright © 2015 Vicente Suarez. All rights reserved.
//

/*
Copyright (c) 2015, Bryan Keller. All rights reserved.
Licensed under the MIT license <http://opensource.org/licenses/MIT>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portionsof the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/


import UIKit

/**
    The FlexibleHeightBarSubviewLayoutAttributes class is used to define layout attributes (i.e frame, transform, alpha) for subviews of a FlexibleHeightBar.
    Note: This class is heavily influenced by UICollectionViewLayoutAttributes.
*/
class FlexibleHeightBarSubviewLayoutAttributes {
    
    private let boundsAssertionMessage = "Bounds must be set with a (0,0) origin"
    
    var alpha: CGFloat = 1.0 // Possible values are between 0.0 (transparent) and 1.0 (opaque). The default is 1.0.
    var zIndex = 0.0 // Specifies the item’s position on the z axis.
    var hidden = false
   
    // MARK: - Computed Properties -
    
    /**
        The frame rectangle of the item.
        The frame rectangle is measured in points and specified in the coordinate system of the collection view. Setting the value of this property also sets the values of the center and size properties.
    */
    var frame: CGRect {
        get {
            return _frame
        }
        set(newFrame) {
            if CGAffineTransformIsIdentity(_transform) && CATransform3DIsIdentity(_transform3D) {
                _frame = newFrame
            }
            
            _center = CGPointMake(CGRectGetMidX(newFrame), CGRectGetMidY(newFrame));
            _size = CGSizeMake(CGRectGetWidth(_frame), CGRectGetHeight(_frame))
            _bounds = CGRectMake(CGRectGetMinX(_bounds), CGRectGetMinY(_bounds), _size.width, _size.height)
        }
    }
    var _frame = CGRectZero
    
    /**
        The bounds of the item.
        When setting the bounds, the origin of the bounds rectangle must always be at (0, 0). Changing the bounds rectangle also changes the value in the size property to match the new bounds size.
    */
    var bounds: CGRect {
        get {
            return _bounds
        }
        set (newBounds) {
            assert(newBounds.origin.x == 0.0 && newBounds.origin.y == 0.0, boundsAssertionMessage)
            _bounds = newBounds
            _size = CGSizeMake(CGRectGetWidth(_bounds), CGRectGetHeight(_bounds))
        }
    }
    var _bounds = CGRectZero
    
    /**
        The center point of the item.
        The center point is specified in the coordinate system of the collection view. Setting the value of this property also updates the origin of the rectangle in the frame property.
    */
    var center: CGPoint {
        get {
            return _center
        }
        set (newCenter) {
            _center = newCenter;
            
            if CGAffineTransformIsIdentity(_transform) && CATransform3DIsIdentity(_transform3D) {
                _frame = CGRectMake(newCenter.x-CGRectGetMidX(_bounds), newCenter.y-CGRectGetMidY(_bounds), CGRectGetWidth(_frame), CGRectGetHeight(_frame))
            }
        }
    }
    var _center = CGPointZero
    
    /**
        The size of the item.
        Setting the value of this property also changes the size of the rectangle returned by the frame and bounds properties.
    */
    var size: CGSize {
        get {
            return _size
        }
        set (newSize) {
            _size = newSize
            
            if CGAffineTransformIsIdentity(_transform) && CATransform3DIsIdentity(_transform3D) {
                _frame = CGRectMake(CGRectGetMinX(_frame), CGRectGetMinY(_frame), newSize.width, newSize.height)
            }
            
            _bounds = CGRectMake(CGRectGetMinX(_bounds), CGRectGetMinY(_bounds), newSize.width, newSize.height)
        }
    }
    var _size = CGSizeZero
    
    /**
        The 3D transform of the item.
        Assigning a transform other than the identity transform to this property causes the frame property to be set to CGRectNull. Assigning a value also replaces the value in the transform property with an affine version of the 3D transform you specify.
    */
    var transform3D: CATransform3D {
        get {
            return _transform3D
        }
        set (newTransform3D) {
            _transform3D = newTransform3D
            
            _transform = CGAffineTransformMake(newTransform3D.m11, newTransform3D.m12, newTransform3D.m21, newTransform3D.m22, newTransform3D.m41, newTransform3D.m42)
            
            if !CATransform3DIsIdentity(newTransform3D) {
                _frame = CGRectNull;
            }
        }
    }
    var _transform3D = CATransform3DIdentity
    
    /**
        The affine transform of the item.
        Assigning a transform other than the identity transform to this property causes the frame property to be set to CGRectNull. Assigning a value also replaces the value in the transform3D property with a 3D version of the affine transform you specify.
    */
    var transform: CGAffineTransform {
        get {
            return _transform
        }
        set (newTransform) {
            _transform = newTransform
            
            _transform3D = CATransform3DMakeAffineTransform(newTransform)
            
            if !CGAffineTransformIsIdentity(newTransform) {
                _frame = CGRectNull
            }
        }
    }
    var _transform = CGAffineTransformIdentity
    
    var cornerRadius: CGFloat {
        get {
            return _cornerRadius
        }
        set (newCornerRadius) {
            _cornerRadius = fmax(newCornerRadius, 0.0)
        }
    }
    var _cornerRadius: CGFloat = 0.0
    
    // MARK: - Initialization -
    
    init() {
    }
    
    
    /** 
        A convenience initializer that returns layout attributes with the same property values as the specified layout attributes, or nil of initialization fails.
    
        - Parameter layoutAttributes: The existing layout attributes.
        - Returns: Layout attributes with the same property values as the specified layout attributes, or nil of initialization fails.
    */
    convenience init(layoutAttributes: FlexibleHeightBarSubviewLayoutAttributes) {
        self.init()
        _frame = layoutAttributes.frame
        _bounds = layoutAttributes.bounds
        _center = layoutAttributes.center
        _size = layoutAttributes.size
        _transform3D = layoutAttributes.transform3D
        _transform = layoutAttributes.transform
        alpha = layoutAttributes.alpha
        zIndex = layoutAttributes.zIndex
        hidden = layoutAttributes.hidden
    }
}

extension FlexibleHeightBarSubviewLayoutAttributes: CustomStringConvertible {
    
    var description: String {
        get {
            return "FlexibleHeightBarSubviewLayoutAttributes = {\n\talpha: \(alpha)\n\tzIndex: \(zIndex)\n\thidden: \(hidden)\n\tframe: \(frame)\n\tbounds: \(bounds)\n\tcenter: \(center)\n\tsize: \(size)\n\ttransform3D: \(transform3D)\n\ttransform: \(transform)\n}"
        }
    }
}
