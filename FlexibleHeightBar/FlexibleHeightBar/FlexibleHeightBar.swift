
//  FlexibleHeightBar.swift
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
    The FlexibleHeightBar class is responsible for adjusting the layout attributes (i.e. frame, transform, alpha) of its subviews depending on its current height.

    The height of the bar is not set directy by adjusting the bar's frame. Rather, height adjustments are made by setting the progress property of the bar. The progress property represents how much the bar has shrunk, with 0% progress being the bar's full height and 100% progress being the bar's minimum height.

    FlexibleHeightBar is designed to support any shrinking / growing behavior. For example, Safari's shrinking header and Facebook's shrinking header behave differently. Bar behaviors can be mix and matched (and hot swapped) by setting the bar's behaviorDefiner property.
*/
open class FlexibleHeightBar: UIView {
    
    // MARK: - Properties -
    
    private var subviewLayoutAttributes = [UIView: [CGFloat: FlexibleHeightBarSubviewLayoutAttributes]]()
    private var layoutConstraintConstants = [NSLayoutConstraint: [CGFloat: CGFloat]]()
    
    public var heightConstraint: NSLayoutConstraint?
    public var useAutoLayout: Bool {
        if let _ = heightConstraint {
            return true
        }
        return false
    }
    
    /// The non-negative maximum height for the bar. The default value is **44.0**.
    public var maximumBarHeight: CGFloat {
        get {
            return _maximumBarHeight
        }
        set (newMaximumBarHeight) {
            _maximumBarHeight = fmax(newMaximumBarHeight, 0.0)
        }
    }
    private var _maximumBarHeight: CGFloat = 44.0
    
    /// The non-negative minimum height for the bar. The default value is **20.0**.
    public var minimumBarHeight: CGFloat {
        get {
            return _minimumBarHeight
        }
        set (newMinimumBarHeight) {
            _minimumBarHeight = fmax(newMinimumBarHeight, 0.0)
        }
    }
    private var _minimumBarHeight: CGFloat = 20.0
    
    /**
        The current progress, representing how much the bar has shrunk. *progress == 0.0* puts the bar at its maximum height. *progress == 1.0* puts the bar at its minimum height. The default value is **0.0**.
        progress is bounded between *0.0* and *1.0* inclusive unless the bar's behaviorDefiner instance has its elasticMaximumHeightAtTop set to *true*.
    */
    public var progress: CGFloat {
        get {
            return _progress
        }
        set (newProgress) {
            _progress = fmin(newProgress, 1.0)
            
            if let bhvrDefr = behaviorDefiner {
                if !bhvrDefr.elasticMaximumHeightAtTop {
                    _progress = fmax(_progress, 0.0)
                }
            } else {
                _progress = fmax(_progress, 0.0)
            }
        }
    }
    private var _progress: CGFloat = 0.0
    
    /**
        The behavior definer for the bar. Behavior definers are instances of FlexibleHeightBarBehaviorDefiner. Behavior definers can be changed at run time to provide a different behavior.
    */
    public var behaviorDefiner: FlexibleHeightBarBehaviorDefiner? {
        get {
            return _behaviorDefiner
        }
        set (newBehaviorDefiner) {
            _behaviorDefiner = newBehaviorDefiner
            
            if let behDef = _behaviorDefiner {
                behDef.flexibleHeightBar = self
            }
        }
    }
    private var _behaviorDefiner: FlexibleHeightBarBehaviorDefiner?
    
    // MARK: - Initialization -
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        _maximumBarHeight = frame.maxY
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        maximumBarHeight = bounds.maxY
    }
    
    // MARK: - Layout attributes -
    
    /**
    Add layout attributes that correspond to a progress value for a `FlexibleHeightBar` subview.
    - Parameter attributes: The layout attributes that the receiver wants to be applied to the specified `FlexibleHeightBar` subview.
    - Parameter subview: The receiver's subview to a apply the layout attributes to.
    - Parameter progress: The progress value (between *0.0* and *1.0* inclusive) that the receiver instance will use to decide which layout attributes to apply.
    */
    public func addLayoutAttributes(_ attributes: FlexibleHeightBarSubviewLayoutAttributes, forSubview subview: UIView, forProgress barProgress: CGFloat) {
        
        // Init lazily
        if let _ = subviewLayoutAttributes[subview] {} else {
            subviewLayoutAttributes[subview] = [CGFloat: FlexibleHeightBarSubviewLayoutAttributes]()
        }
        
        // Make sure the progress is between 0 and 1
        let newProgress = fmax(fmin(barProgress, 1.0), 0.0)
        
        subviewLayoutAttributes[subview]![newProgress] = attributes
    }
    
    /**
    Remove the layout attributes instance that corresponds to then specified progress value from the specified subview.
    - Parameter subview: The subview to remove the layout attriutes from.
    - Parameter subviewProgress: The progress value corresponding to the layout attributes that are to be removed.
    */
    public func removeLayoutAttributeForSubview(_ subview: UIView, forProgress barProgress: CGFloat) {
        
        subviewLayoutAttributes[subview]?[barProgress] = nil
    }
    
    // MARK: - Layout Constraints -
    
    public func addLayoutConstraintConstant(_ constant: CGFloat, forContraint constraint: NSLayoutConstraint, forProgress barProgress: CGFloat) {
        
        // Init lazily
        if let _ = layoutConstraintConstants[constraint] {} else {
            layoutConstraintConstants[constraint] = [CGFloat: CGFloat]()
        }
        
        // Make sure the progress is between 0 and 1
        let newProgress = fmax(fmin(barProgress, 1.0), 0.0)
        
        layoutConstraintConstants[constraint]![newProgress] = constant
    }
    
    public func removeLayoutConstraintConstantforConstraint(constraint: NSLayoutConstraint, forProgress barProgress: CGFloat) {
        layoutConstraintConstants[constraint]?[barProgress] = nil
    }
    
    // MARK: - Layout Subviews
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // Update height
        if useAutoLayout {
            applyConstraintConstants()
            heightConstraint!.constant = interpolate(from: maximumBarHeight, to: minimumBarHeight, withProgress: progress)
        } else {
            var barFrame = frame
            barFrame.size.height = interpolate(from: maximumBarHeight, to: minimumBarHeight, withProgress: progress)
            frame = barFrame
        }
        
        if let bhvrDefr = behaviorDefiner, !bhvrDefr.elasticMaximumHeightAtTop {
            progress = fmax(self.progress, 0.0)
        }
        
        applyLayoutAttributes()
    }
    
    /**
    Applies the layout Attributes to the specified subview according to the current progress value for the receiver. If the subview has subviews, it checks for layout attributes for subviews as well.
    - Parameter aSubview: The subview to apply the layout attributes.
    */
    private func applyLayoutAttributes() {
        
        for (subview, _) in subviewLayoutAttributes {
            if let keys = subviewLayoutAttributes[subview]?.keys {
                var progAttrKeys = Array(keys)
                
                progAttrKeys.sort(){$0<$1}
                
                for (index, _) in progAttrKeys.enumerated() {
                    let floorProgressPosition = progAttrKeys[index]
                    
                    if index + 1 < progAttrKeys.count {
                        let ceilingProgressPosition = progAttrKeys[index + 1]
                        if progress >= floorProgressPosition && progress < ceilingProgressPosition {
                            let floorLayoutAttributes = subviewLayoutAttributes[subview]?[floorProgressPosition]
                            let ceilingLayoutAttributes = subviewLayoutAttributes[subview]?[ceilingProgressPosition]
                            if let floor = floorLayoutAttributes, let ceiling = ceilingLayoutAttributes {
                                apply(floorLayoutAttributes: floor, ceilingLayoutAttributes: ceiling, toSubview: subview, withFloorProgress: floorProgressPosition, ceilingProgress: ceilingProgressPosition)
                            }
                        }
                    } else {
                        if progress >= floorProgressPosition {
                            let floorLayoutAttributes = subviewLayoutAttributes[subview]?[floorProgressPosition]
                            if let floor = floorLayoutAttributes {
                                apply(floorLayoutAttributes: floor, ceilingLayoutAttributes: floor, toSubview: subview, withFloorProgress: floorProgressPosition, ceilingProgress: floorProgressPosition)
                            }
                        }
                    }
                }
            }
        }
    }
    
    /**
    Applies the Constraint Constants to each constraint according to the current progress value for the receiver. If the subview has subviews, it checks for layout attributes for subviews as well.
    - Parameter aSubview: The subview to apply the layout attributes.
    */
    private func applyConstraintConstants() {
        
        for (constraint, _) in layoutConstraintConstants {
            
            // Get array of keys
            if let keys = layoutConstraintConstants[constraint]?.keys {
                var progConstKeys = Array(keys)
                
                progConstKeys.sort(){$0<$1}
                
                for (index, _) in progConstKeys.enumerated() {
                    let floorProgressPosition = progConstKeys[index]
                    
                    if index + 1 < progConstKeys.count {
                        
                        let ceilingProgressPosition = progConstKeys[index + 1]
                        
                        if progress >= floorProgressPosition && progress < ceilingProgressPosition {
                            
                            let floorConstraintConstant = layoutConstraintConstants[constraint]?[floorProgressPosition]
                            let ceilingConstraintConstant = layoutConstraintConstants[constraint]?[ceilingProgressPosition]
                            
                            if let floor = floorConstraintConstant, let ceiling = ceilingConstraintConstant {
                                // Apply constant
                                let relativeProgress = calculateRelativeProgress(withFloorProgress: floorProgressPosition, ceilingProgress: ceilingProgressPosition)
                                constraint.constant = interpolate(from: floor, to: ceiling, withProgress: relativeProgress)
                            }
                        }
                    } else {
                        if progress >= floorProgressPosition {
                            let floorConstantConstraint = layoutConstraintConstants[constraint]?[floorProgressPosition]
                            
                            if let floor = floorConstantConstraint {
                                // Apply constant
                                let relativeProgress = calculateRelativeProgress(withFloorProgress: floorProgressPosition, ceilingProgress: floorProgressPosition)
                                constraint.constant = interpolate(from: floor, to: floor, withProgress: relativeProgress)
                            }
                        }
                    }
                }
            }
        }
    }
    
    /**
    Applies the layout Attributes to the specified subview according to the current floor and ceiling progress value for the receiver..
    
    - Parameter floorLayoutAttributes: The layout attributes with progress immidiately less than the current layout attributes.
    - Parameter ceilingLayoutAttributes: The layout attributes with progress immidiately greater thatn the current layout attributes.
    - Parameter subview: The subview to apply the extrapolated layout attributes.
    - Parameter floorProgress: The progress immidiately less than the current layout attributes.
    - Parameter ceilingProgress: The progress immidiately greater thatn the current layout attributes
    */
    private func apply(floorLayoutAttributes: FlexibleHeightBarSubviewLayoutAttributes, ceilingLayoutAttributes: FlexibleHeightBarSubviewLayoutAttributes, toSubview subview: UIView, withFloorProgress floorProgress: CGFloat, ceilingProgress: CGFloat) {
        
        let relativeProgress = calculateRelativeProgress(withFloorProgress: floorProgress, ceilingProgress: ceilingProgress)
        
        if useAutoLayout {
            
            subview.layer.cornerRadius = interpolate(from: floorLayoutAttributes.cornerRadius, to: ceilingLayoutAttributes.cornerRadius, withProgress: relativeProgress)
        } else {
            
            // Interpolate CA3DTransform
            var transform3D = CATransform3D()
            transform3D.m11 = interpolate(from: floorLayoutAttributes.transform3D.m11, to: ceilingLayoutAttributes.transform3D.m11, withProgress: relativeProgress)
            transform3D.m12 = interpolate(from: floorLayoutAttributes.transform3D.m12, to: ceilingLayoutAttributes.transform3D.m12, withProgress: relativeProgress)
            transform3D.m13 = interpolate(from: floorLayoutAttributes.transform3D.m13, to: ceilingLayoutAttributes.transform3D.m13, withProgress: relativeProgress)
            transform3D.m14 = interpolate(from: floorLayoutAttributes.transform3D.m14, to: ceilingLayoutAttributes.transform3D.m14, withProgress: relativeProgress)
            transform3D.m21 = interpolate(from: floorLayoutAttributes.transform3D.m21, to: ceilingLayoutAttributes.transform3D.m21, withProgress: relativeProgress)
            transform3D.m22 = interpolate(from: floorLayoutAttributes.transform3D.m22, to: ceilingLayoutAttributes.transform3D.m22, withProgress: relativeProgress)
            transform3D.m23 = interpolate(from: floorLayoutAttributes.transform3D.m23, to: ceilingLayoutAttributes.transform3D.m23, withProgress: relativeProgress)
            transform3D.m24 = interpolate(from: floorLayoutAttributes.transform3D.m24, to: ceilingLayoutAttributes.transform3D.m24, withProgress: relativeProgress)
            transform3D.m31 = interpolate(from: floorLayoutAttributes.transform3D.m31, to: ceilingLayoutAttributes.transform3D.m31, withProgress: relativeProgress)
            transform3D.m32 = interpolate(from: floorLayoutAttributes.transform3D.m32, to: ceilingLayoutAttributes.transform3D.m32, withProgress: relativeProgress)
            transform3D.m33 = interpolate(from: floorLayoutAttributes.transform3D.m33, to: ceilingLayoutAttributes.transform3D.m33, withProgress: relativeProgress)
            transform3D.m34 = interpolate(from: floorLayoutAttributes.transform3D.m34, to: ceilingLayoutAttributes.transform3D.m34, withProgress: relativeProgress)
            transform3D.m41 = interpolate(from: floorLayoutAttributes.transform3D.m41, to: ceilingLayoutAttributes.transform3D.m41, withProgress: relativeProgress)
            transform3D.m42 = interpolate(from: floorLayoutAttributes.transform3D.m42, to: ceilingLayoutAttributes.transform3D.m42, withProgress: relativeProgress)
            transform3D.m43 = interpolate(from: floorLayoutAttributes.transform3D.m43, to: ceilingLayoutAttributes.transform3D.m43, withProgress: relativeProgress)
            transform3D.m44 = interpolate(from: floorLayoutAttributes.transform3D.m44, to: ceilingLayoutAttributes.transform3D.m44, withProgress: relativeProgress)
            
            // Interpolate frame
            let frame: CGRect
            
            if !floorLayoutAttributes.frame.equalTo(CGRect.null) && ceilingLayoutAttributes.frame.equalTo(CGRect.null) {
                frame = floorLayoutAttributes.frame
            } else if floorLayoutAttributes.frame.equalTo(CGRect.null) && ceilingLayoutAttributes.frame.equalTo(CGRect.null) {
                frame = subview.frame
            } else {
                let x = interpolate(from: floorLayoutAttributes.frame.minX, to: ceilingLayoutAttributes.frame.minX, withProgress: relativeProgress)
                let y = interpolate(from: floorLayoutAttributes.frame.minY, to: ceilingLayoutAttributes.frame.minY, withProgress: relativeProgress)
                let width = interpolate(from: floorLayoutAttributes.frame.width, to: ceilingLayoutAttributes.frame.width, withProgress: relativeProgress)
                let height = interpolate(from: floorLayoutAttributes.frame.height, to: ceilingLayoutAttributes.frame.height, withProgress: relativeProgress)
                frame = CGRect(x: x, y: y, width: width, height: height)
            }
            
            // Interpolate center
            var x = interpolate(from: floorLayoutAttributes.center.x, to: ceilingLayoutAttributes.center.x, withProgress: relativeProgress)
            var y = interpolate(from: floorLayoutAttributes.center.y, to: ceilingLayoutAttributes.center.y, withProgress: relativeProgress)
            let center = CGPoint(x: x, y: y)
            
            // Interpolate bounds
            x = interpolate(from: floorLayoutAttributes.bounds.minX, to: ceilingLayoutAttributes.bounds.minX, withProgress: relativeProgress)
            y = interpolate(from: floorLayoutAttributes.bounds.minY, to: ceilingLayoutAttributes.bounds.minY, withProgress: relativeProgress)
            let width = interpolate(from: floorLayoutAttributes.bounds.width, to: ceilingLayoutAttributes.bounds.width, withProgress: relativeProgress)
            let height = interpolate(from: floorLayoutAttributes.bounds.height, to: ceilingLayoutAttributes.bounds.height, withProgress: relativeProgress)
            let bounds = CGRect(x: x, y: y, width: width, height: height)
            
            // Apply updated attributes
            subview.layer.transform = transform3D
            if CATransform3DIsIdentity(transform3D) {
                subview.frame = frame
            }
            
            subview.center = center
            subview.bounds = bounds
            
        }
        
        // Interpolate alpha
        let alpha = interpolate(from: floorLayoutAttributes.alpha, to: ceilingLayoutAttributes.alpha, withProgress: relativeProgress)
        
        subview.alpha = alpha
        subview.layer.zPosition = CGFloat(floorLayoutAttributes.zIndex)
        subview.isHidden = floorLayoutAttributes.hidden
    }
    
    private func calculateRelativeProgress(withFloorProgress floorProgress: CGFloat, ceilingProgress: CGFloat) -> CGFloat {
        
        let numerator = progress - floorProgress
        let denominator: CGFloat
        
        if ceilingProgress == floorProgress {
            denominator = ceilingProgress
        } else {
            denominator = ceilingProgress - floorProgress
        }
        
        return numerator / denominator
    }
    
    /**
    Calculates a value between to values according to the sepcified progress value.
    
    - Parameter fromValue: The first value.
    - Parameter toValue: The second value.
    - Parameter progress:  The progress that provides the ratio to apply to the two specified values.
    - Returns: The interpolated value.
    */
    private func interpolate(from fromValue: CGFloat, to toValue: CGFloat, withProgress progress: CGFloat) -> CGFloat {
        return fromValue - ((fromValue - toValue) * progress)
    }
}
