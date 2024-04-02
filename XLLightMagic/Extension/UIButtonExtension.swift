//
//  UIButtonExtension.swift
//  XLLightMagic
//
//  Created by admin on 2024/4/2.
//

import UIKit
private var ExtendEdgeInsetsKey: Void?

extension UIButton {
    
    var extendEdgeInsets: UIEdgeInsets {
        get {
            return objc_getAssociatedObject(self, &ExtendEdgeInsetsKey) as? UIEdgeInsets ?? UIEdgeInsets.zero
        }
        set {
            objc_setAssociatedObject(self, &ExtendEdgeInsetsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if (extendEdgeInsets == .zero) || !self.isEnabled || self.isHidden || self.alpha < 0.01 {
            return super.point(inside: point, with: event)
        }
        let newRect = extendRect(bounds, extendEdgeInsets)
        return newRect.contains(point)
    }
    
    private func extendRect(_ rect: CGRect, _ edgeInsets: UIEdgeInsets) -> CGRect {
        let x = rect.minX - edgeInsets.left
        let y = rect.minY - edgeInsets.top
        let w = rect.width + edgeInsets.left + edgeInsets.right
        let h = rect.height + edgeInsets.top + edgeInsets.bottom
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    
    /// SwifterSwift: Set background color for specified state.
    /// - Parameters:
    ///   - color: The color of the image that will be set as background for the button in the given state.
    ///   - forState: set the UIControl.State for the desired color.
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        clipsToBounds = true // maintain corner radius
        
        let colorImage = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { context in
            color.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            draw(.zero)
        }
        setBackgroundImage(colorImage, for: forState)
    }
}
