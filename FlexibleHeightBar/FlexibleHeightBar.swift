
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
class FlexibleHeightBar: UIView {
    
    // MARK: - Properties -
    
    private var subviewLayoutAttributes = [UIView: [CGFloat: FlexibleHeightBarSubviewLayoutAttributes]]()
    private var layoutConstraintConstants = [NSLayoutConstraint: [CGFloat: CGFloat]]()
    
    var heightConstraint: NSLayoutConstraint?
    var useAutoLayout: Bool {
        if let _ = heightConstraint {
            return true
        }
        return false
    }
    
    /// The non-negative maximum height for the bar. The default value is **44.0**.
    var maximumBarHeight: CGFloat {
        get {
            return _maximumBarHeight
        }
        set (newMaximumBarHeight) {
            _maximumBarHeight = fmax(newMaximumBarHeight, 0.0)
        }
    }
    var _maximumBarHeight: CGFloat = 44.0
    
    /// The non-negative minimum height for the bar. The default value is **20.0**.
    var minimumBarHeight: CGFloat {
        get {
            return _minimumBarHeight
        }
        set (newMinimumBarHeight) {
            _minimumBarHeight = fmax(newMinimumBarHeight, 0.0)
        }
    }
    var _minimumBarHeight: CGFloat = 20.0
    
    /**
        The current progress, representing how much the bar has shrunk. *progress == 0.0* puts the bar at its maximum height. *progress == 1.0* puts the bar at its minimum height. The default value is **0.0**.
        progress is bounded between *0.0* and *1.0* inclusive unless the bar's behaviorDefiner instance has its elasticMaximumHeightAtTop set to *true*.
    */
    var progress: CGFloat {
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
    var _progress: CGFloat = 0.0
    
    /**
        The behavior definer for the bar. Behavior definers are instances of FlexibleHeightBarBehaviorDefiner. Behavior definers can be changed at run time to provide a different behavior.
    */
    var behaviorDefiner: FlexibleHeightBarBehaviorDefiner? {
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
    var _behaviorDefiner: FlexibleHeightBarBehaviorDefiner?
    
    // MARK: - Initialization -
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _maximumBarHeight = CGRectGetMaxY(frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        maximumBarHeight = CGRectGetMaxY(bounds)
    }
    
    // MARK: - Layout attributes -
    
    /**
    Add layout attributes that correspond to a progress value for a `FlexibleHeightBar` subview.
    - Parameter attributes: The layout attributes that the receiver wants to be applied to the specified `FlexibleHeightBar` subview.
    - Parameter subview: The receiver's subview to a apply the layout attributes to.
    - Parameter progress: The progress value (between *0.0* and *1.0* inclusive) that the receiver instance will use to decide which layout attributes to apply.
    */
    func addLayoutAttributes(attributes: FlexibleHeightBarSubviewLayoutAttributes, forSubview subview: UIView, forProgress barProgress: CGFloat) {
        
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
    func removeLayoutAttributeForSubview(subview: UIView, forProgress barProgress: CGFloat) {
        
        subviewLayoutAttributes[subview]?[barProgress] = nil
    }
    
    // MARK: - Layout Constraints -
    
    func addLayoutConstraintConstant(constant: CGFloat, forContraint constraint: NSLayoutConstraint, forProgress barProgress: CGFloat) {
        
        // Init lazily
        if let _ = layoutConstraintConstants[constraint] {} else {
            layoutConstraintConstants[constraint] = [CGFloat: CGFloat]()
        }
        
        // Make sure the progress is between 0 and 1
        let newProgress = fmax(fmin(barProgress, 1.0), 0.0)
        
        layoutConstraintConstants[constraint]![newProgress] = constant
    }
    
    func removeLayoutConstraintConstantforConstraint(constraint: NSLayoutConstraint, forProgress barProgress: CGFloat) {
        layoutConstraintConstants[constraint]?[barProgress] = nil
    }
    
    // MARK: - Layout Subviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update height
        if useAutoLayout {
            applyConstraintConstants()
            heightConstraint!.constant = interpolateFromValue(maximumBarHeight, toValue: minimumBarHeight, withProgress: progress)
        } else {
            var barFrame = frame
            barFrame.size.height = interpolateFromValue(maximumBarHeight, toValue: minimumBarHeight, withProgress: progress)
            frame = barFrame
        }
        
        if let bhvrDefr = behaviorDefiner where !bhvrDefr.elasticMaximumHeightAtTop {
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
            
            if var progAttrKeys = subviewLayoutAttributes[subview]?.keys.array {
                
                progAttrKeys.sortInPlace(){$0<$1}
                
                for var index = 0 ; index < progAttrKeys.count ; index++ {
                    let floorProgressPosition = progAttrKeys[index]
                    
                    if index + 1 < progAttrKeys.count {
                        let ceilingProgressPosition = progAttrKeys[index + 1]
                        if progress >= floorProgressPosition && progress < ceilingProgressPosition {
                            let floorLayoutAttributes = subviewLayoutAttributes[subview]?[floorProgressPosition]
                            let ceilingLayoutAttributes = subviewLayoutAttributes[subview]?[ceilingProgressPosition]
                            if let floor = floorLayoutAttributes, ceiling = ceilingLayoutAttributes {
                                applyFloorLayoutAttributes(floor, ceilingLayoutAttributes: ceiling, toSubview: subview, withFloorProgress: floorProgressPosition, ceilingProgress: ceilingProgressPosition)
                            }
                        }
                    } else {
                        if progress >= floorProgressPosition {
                            let floorLayoutAttributes = subviewLayoutAttributes[subview]?[floorProgressPosition]
                            if let floor = floorLayoutAttributes {
                                applyFloorLayoutAttributes(floor, ceilingLayoutAttributes: floor, toSubview: subview, withFloorProgress: floorProgressPosition, ceilingProgress: floorProgressPosition)
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
    func applyConstraintConstants() {
        
        for (constraint, _) in layoutConstraintConstants {
            
            // Get array of keys
            if var progConstKeys = layoutConstraintConstants[constraint]?.keys.array {
                
                progConstKeys.sortInPlace(){$0<$1}
                
                for var index = 0 ; index < progConstKeys.count ; index++ {
                    
                    let floorProgressPosition = progConstKeys[index]
                    
                    if index + 1 < progConstKeys.count {
                        
                        let ceilingProgressPosition = progConstKeys[index + 1]
                        
                        if progress >= floorProgressPosition && progress < ceilingProgressPosition {
                            
                            let floorConstraintConstant = layoutConstraintConstants[constraint]?[floorProgressPosition]
                            let ceilingConstraintConstant = layoutConstraintConstants[constraint]?[ceilingProgressPosition]
                            
                            if let floor = floorConstraintConstant, ceiling = ceilingConstraintConstant {
                                // Apply constant
                                let relativeProgress = calculateRelativeProgressWithfloorProgress(floorProgressPosition, ceilingProgress: ceilingProgressPosition)
                                constraint.constant = interpolateFromValue(floor, toValue: ceiling, withProgress: relativeProgress)
                            }
                        }
                    } else {
                        if progress >= floorProgressPosition {
                            let floorConstantConstraint = layoutConstraintConstants[constraint]?[floorProgressPosition]
                            
                            if let floor = floorConstantConstraint {
                                // Apply constant
                                let relativeProgress = calculateRelativeProgressWithfloorProgress(floorProgressPosition, ceilingProgress: floorProgressPosition)
                                constraint.constant = interpolateFromValue(floor, toValue: floor, withProgress: relativeProgress)
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
    func applyFloorLayoutAttributes(floorLayoutAttributes: FlexibleHeightBarSubviewLayoutAttributes, ceilingLayoutAttributes: FlexibleHeightBarSubviewLayoutAttributes, toSubview subview: UIView, withFloorProgress floorProgress: CGFloat, ceilingProgress: CGFloat) {
        
        let relativeProgress = calculateRelativeProgressWithfloorProgress(floorProgress, ceilingProgress: ceilingProgress)
        
        if useAutoLayout {
            
            subview.layer.cornerRadius = interpolateFromValue(floorLayoutAttributes.cornerRadius, toValue: ceilingLayoutAttributes.cornerRadius, withProgress: relativeProgress)
        } else {
            
            // Interpolate CA3DTransform
            var transform3D = CATransform3D()
            transform3D.m11 = interpolateFromValue(floorLayoutAttributes.transform3D.m11, toValue: ceilingLayoutAttributes.transform3D.m11, withProgress: relativeProgress)
            transform3D.m12 = interpolateFromValue(floorLayoutAttributes.transform3D.m12, toValue: ceilingLayoutAttributes.transform3D.m12, withProgress: relativeProgress)
            transform3D.m13 = interpolateFromValue(floorLayoutAttributes.transform3D.m13, toValue: ceilingLayoutAttributes.transform3D.m13, withProgress: relativeProgress)
            transform3D.m14 = interpolateFromValue(floorLayoutAttributes.transform3D.m14, toValue: ceilingLayoutAttributes.transform3D.m14, withProgress: relativeProgress)
            transform3D.m21 = interpolateFromValue(floorLayoutAttributes.transform3D.m21, toValue: ceilingLayoutAttributes.transform3D.m21, withProgress: relativeProgress)
            transform3D.m22 = interpolateFromValue(floorLayoutAttributes.transform3D.m22, toValue: ceilingLayoutAttributes.transform3D.m22, withProgress: relativeProgress)
            transform3D.m23 = interpolateFromValue(floorLayoutAttributes.transform3D.m23, toValue: ceilingLayoutAttributes.transform3D.m23, withProgress: relativeProgress)
            transform3D.m24 = interpolateFromValue(floorLayoutAttributes.transform3D.m24, toValue: ceilingLayoutAttributes.transform3D.m24, withProgress: relativeProgress)
            transform3D.m31 = interpolateFromValue(floorLayoutAttributes.transform3D.m31, toValue: ceilingLayoutAttributes.transform3D.m31, withProgress: relativeProgress)
            transform3D.m32 = interpolateFromValue(floorLayoutAttributes.transform3D.m32, toValue: ceilingLayoutAttributes.transform3D.m32, withProgress: relativeProgress)
            transform3D.m33 = interpolateFromValue(floorLayoutAttributes.transform3D.m33, toValue: ceilingLayoutAttributes.transform3D.m33, withProgress: relativeProgress)
            transform3D.m34 = interpolateFromValue(floorLayoutAttributes.transform3D.m34, toValue: ceilingLayoutAttributes.transform3D.m34, withProgress: relativeProgress)
            transform3D.m41 = interpolateFromValue(floorLayoutAttributes.transform3D.m41, toValue: ceilingLayoutAttributes.transform3D.m41, withProgress: relativeProgress)
            transform3D.m42 = interpolateFromValue(floorLayoutAttributes.transform3D.m42, toValue: ceilingLayoutAttributes.transform3D.m42, withProgress: relativeProgress)
            transform3D.m43 = interpolateFromValue(floorLayoutAttributes.transform3D.m43, toValue: ceilingLayoutAttributes.transform3D.m43, withProgress: relativeProgress)
            transform3D.m44 = interpolateFromValue(floorLayoutAttributes.transform3D.m44, toValue: ceilingLayoutAttributes.transform3D.m44, withProgress: relativeProgress)
            
            // Interpolate frame
            let frame: CGRect
            
            if !CGRectEqualToRect(floorLayoutAttributes.frame, CGRectNull) && CGRectEqualToRect(ceilingLayoutAttributes.frame, CGRectNull) {
                frame = floorLayoutAttributes.frame
            } else if CGRectEqualToRect(floorLayoutAttributes.frame, CGRectNull) && CGRectEqualToRect(ceilingLayoutAttributes.frame, CGRectNull) {
                frame = subview.frame
            } else {
                let x = interpolateFromValue(CGRectGetMinX(floorLayoutAttributes.frame), toValue: CGRectGetMinX(ceilingLayoutAttributes.frame), withProgress: relativeProgress)
                let y = interpolateFromValue(CGRectGetMinY(floorLayoutAttributes.frame), toValue: CGRectGetMinY(ceilingLayoutAttributes.frame), withProgress: relativeProgress)
                let width = interpolateFromValue(CGRectGetWidth(floorLayoutAttributes.frame), toValue: CGRectGetWidth(ceilingLayoutAttributes.frame), withProgress: relativeProgress)
                let height = interpolateFromValue(CGRectGetHeight(floorLayoutAttributes.frame), toValue: CGRectGetHeight(ceilingLayoutAttributes.frame), withProgress: relativeProgress)
                frame = CGRectMake(x, y, width, height)
            }
            
            // Interpolate center
            var x = interpolateFromValue(floorLayoutAttributes.center.x, toValue: ceilingLayoutAttributes.center.x, withProgress: relativeProgress)
            var y = interpolateFromValue(floorLayoutAttributes.center.y, toValue: ceilingLayoutAttributes.center.y, withProgress: relativeProgress)
            let center = CGPointMake(x, y)
            
            // Interpolate bounds
            x = interpolateFromValue(CGRectGetMinX(floorLayoutAttributes.bounds), toValue: CGRectGetMinX(ceilingLayoutAttributes.bounds), withProgress: relativeProgress)
            y = interpolateFromValue(CGRectGetMinY(floorLayoutAttributes.bounds), toValue: CGRectGetMinY(ceilingLayoutAttributes.bounds), withProgress: relativeProgress)
            let width = interpolateFromValue(CGRectGetWidth(floorLayoutAttributes.bounds), toValue: CGRectGetWidth(ceilingLayoutAttributes.bounds), withProgress: relativeProgress)
            let height = interpolateFromValue(CGRectGetHeight(floorLayoutAttributes.bounds), toValue: CGRectGetHeight(ceilingLayoutAttributes.bounds), withProgress: relativeProgress)
            let bounds = CGRectMake(x, y, width, height)
            
            // Apply updated attributes
            subview.layer.transform = transform3D
            if CATransform3DIsIdentity(transform3D) {
                subview.frame = frame
            }
            
            subview.center = center
            subview.bounds = bounds
            
        }
        
        // Interpolate alpha
        let alpha = interpolateFromValue(floorLayoutAttributes.alpha, toValue: ceilingLayoutAttributes.alpha, withProgress: relativeProgress)
        
        subview.alpha = alpha
        subview.layer.zPosition = CGFloat(floorLayoutAttributes.zIndex)
        subview.hidden = floorLayoutAttributes.hidden
    }
    
    func calculateRelativeProgressWithfloorProgress(floorProgress: CGFloat, ceilingProgress: CGFloat) -> CGFloat {
        
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
    private func interpolateFromValue(fromValue: CGFloat, toValue: CGFloat, withProgress progress: CGFloat) -> CGFloat {
        return fromValue - ((fromValue - toValue) * progress)
    }
}