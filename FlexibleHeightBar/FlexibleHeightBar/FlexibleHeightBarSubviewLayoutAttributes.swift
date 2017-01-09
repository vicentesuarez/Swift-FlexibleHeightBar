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
public class FlexibleHeightBarSubviewLayoutAttributes {
    
    private let boundsAssertionMessage = "Bounds must be set with a (0,0) origin"
    
    public var alpha: CGFloat = 1.0 // Possible values are between 0.0 (transparent) and 1.0 (opaque). The default is 1.0.
    public var zIndex = 0.0 // Specifies the item’s position on the z axis.
    public var hidden = false
   
    // MARK: - Computed Properties -
    
    /**
        The frame rectangle of the item.
        The frame rectangle is measured in points and specified in the coordinate system of the collection view. Setting the value of this property also sets the values of the center and size properties.
    */
    public var frame: CGRect {
        get {
            return _frame
        }
        set(newFrame) {
            if _transform.isIdentity && CATransform3DIsIdentity(_transform3D) {
                _frame = newFrame
            }
            
            _center = CGPoint(x: newFrame.midX, y: newFrame.midY);
            _size = CGSize(width: _frame.width, height: _frame.height)
            _bounds = CGRect(x: _bounds.minX, y: _bounds.minY, width: _size.width, height: _size.height)
        }
    }
    private var _frame = CGRect.zero
    
    /**
        The bounds of the item.
        When setting the bounds, the origin of the bounds rectangle must always be at (0, 0). Changing the bounds rectangle also changes the value in the size property to match the new bounds size.
    */
    public var bounds: CGRect {
        get {
            return _bounds
        }
        set (newBounds) {
            assert(newBounds.origin.x == 0.0 && newBounds.origin.y == 0.0, boundsAssertionMessage)
            _bounds = newBounds
            _size = CGSize(width: _bounds.width, height: _bounds.height)
        }
    }
    private var _bounds = CGRect.zero
    
    /**
        The center point of the item.
        The center point is specified in the coordinate system of the collection view. Setting the value of this property also updates the origin of the rectangle in the frame property.
    */
    public var center: CGPoint {
        get {
            return _center
        }
        set (newCenter) {
            _center = newCenter;
            
            if _transform.isIdentity && CATransform3DIsIdentity(_transform3D) {
                _frame = CGRect(x: newCenter.x - _bounds.midX, y: newCenter.y - _bounds.midY, width: _frame.width, height: _frame.height)
            }
        }
    }
    private var _center = CGPoint.zero
    
    /**
        The size of the item.
        Setting the value of this property also changes the size of the rectangle returned by the frame and bounds properties.
    */
    public var size: CGSize {
        get {
            return _size
        }
        set (newSize) {
            _size = newSize
            
            if _transform.isIdentity && CATransform3DIsIdentity(_transform3D) {
                _frame = CGRect(x: _frame.minX, y: _frame.minY, width: newSize.width, height: newSize.height)
            }
            
            _bounds = CGRect(x: _bounds.minX, y: _bounds.minY, width: newSize.width, height: newSize.height)
        }
    }
    private var _size = CGSize.zero
    
    /**
        The 3D transform of the item.
        Assigning a transform other than the identity transform to this property causes the frame property to be set to CGRectNull. Assigning a value also replaces the value in the transform property with an affine version of the 3D transform you specify.
    */
    public var transform3D: CATransform3D {
        get {
            return _transform3D
        }
        set (newTransform3D) {
            _transform3D = newTransform3D
            
            _transform = CGAffineTransform(a: newTransform3D.m11, b: newTransform3D.m12, c: newTransform3D.m21, d: newTransform3D.m22, tx: newTransform3D.m41, ty: newTransform3D.m42)
            
            if !CATransform3DIsIdentity(newTransform3D) {
                _frame = CGRect.null;
            }
        }
    }
    private var _transform3D = CATransform3DIdentity
    
    /**
        The affine transform of the item.
        Assigning a transform other than the identity transform to this property causes the frame property to be set to CGRectNull. Assigning a value also replaces the value in the transform3D property with a 3D version of the affine transform you specify.
    */
    public var transform: CGAffineTransform {
        get {
            return _transform
        }
        set (newTransform) {
            _transform = newTransform
            
            _transform3D = CATransform3DMakeAffineTransform(newTransform)
            
            if !newTransform.isIdentity {
                _frame = CGRect.null
            }
        }
    }
    private var _transform = CGAffineTransform.identity
    
    public var cornerRadius: CGFloat {
        get {
            return _cornerRadius
        }
        set (newCornerRadius) {
            _cornerRadius = fmax(newCornerRadius, 0.0)
        }
    }
    private var _cornerRadius: CGFloat = 0.0
    
    // MARK: - Initialization -
    
    public init() {
    }
    
    
    /** 
        A convenience initializer that returns layout attributes with the same property values as the specified layout attributes, or nil of initialization fails.
    
        - Parameter layoutAttributes: The existing layout attributes.
        - Returns: Layout attributes with the same property values as the specified layout attributes, or nil of initialization fails.
    */
    public convenience init(layoutAttributes: FlexibleHeightBarSubviewLayoutAttributes) {
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
    
    public var description: String {
        get {
            return "FlexibleHeightBarSubviewLayoutAttributes = {\n\talpha: \(alpha)\n\tzIndex: \(zIndex)\n\thidden: \(hidden)\n\tframe: \(frame)\n\tbounds: \(bounds)\n\tcenter: \(center)\n\tsize: \(size)\n\ttransform3D: \(transform3D)\n\ttransform: \(transform)\n}"
        }
    }
}
