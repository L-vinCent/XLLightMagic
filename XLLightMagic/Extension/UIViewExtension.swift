//
//  UIViewExtension.swift
//  U17
//
//  Created by charles on 2017/11/13.
//  Copyright © 2017年 None. All rights reserved.
//

import UIKit

extension UIView {
    
    
    
    private struct AssociatedKeys {
        static var descriptiveName = "AssociatedKeys.DescriptiveName.blurView"
    }
    
    private (set) var blurView: BlurView {
        get {
            if let blurView = objc_getAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName
                ) as? BlurView {
                return blurView
            }
            self.blurView = BlurView(to: self)
            return self.blurView
        }
        set(blurView) {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName,
                blurView,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    class BlurView {
        
        private var superview: UIView
        private var blur: UIVisualEffectView?
        private var editing: Bool = false
        private (set) var blurContentView: UIView?
        private (set) var vibrancyContentView: UIView?
        
        var animationDuration: TimeInterval = 0.1
        
        /**
         * Blur style. After it is changed all subviews on
         * blurContentView & vibrancyContentView will be deleted.
         */
        var style: UIBlurEffect.Style = .light {
            didSet {
                guard oldValue != style,
                    !editing else { return }
                applyBlurEffect()
            }
        }
        /**
         * Alpha component of view. It can be changed freely.
         */
        var alpha: CGFloat = 0 {
            didSet {
                guard !editing else { return }
                if blur == nil {
                    applyBlurEffect()
                }
                let alpha = self.alpha
                UIView.animate(withDuration: animationDuration) {
                    self.blur?.alpha = alpha
                }
            }
        }
        
        init(to view: UIView) {
            self.superview = view
        }
        
        func setup(style: UIBlurEffect.Style, alpha: CGFloat) -> Self {
            self.editing = true
            
            self.style = style
            self.alpha = alpha
            
            self.editing = false
            
            return self
        }
        
        func enable(isHidden: Bool = false) {
            if blur == nil {
                applyBlurEffect()
            }
            
            self.blur?.isHidden = isHidden
        }
        
        private func applyBlurEffect() {
            blur?.removeFromSuperview()
            
            applyBlurEffect(
                style: style,
                blurAlpha: alpha
            )
        }
        
        private func applyBlurEffect(style: UIBlurEffect.Style,
                                     blurAlpha: CGFloat) {
            superview.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
            let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
            blurEffectView.contentView.addSubview(vibrancyView)
            
            blurEffectView.alpha = blurAlpha
            
            superview.insertSubview(blurEffectView, at: 0)
            
            blurEffectView.addAlignedConstrains()
            vibrancyView.addAlignedConstrains()
            
            self.blur = blurEffectView
            self.blurContentView = blurEffectView.contentView
            self.vibrancyContentView = vibrancyView.contentView
        }
    }
    
    private func addAlignedConstrains() {
        translatesAutoresizingMaskIntoConstraints = false
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.top)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.leading)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.trailing)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.bottom)
    }
    
    private func addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute) {
        superview?.addConstraint(
            NSLayoutConstraint(
                item: self,
                attribute: attribute,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: superview,
                attribute: attribute,
                multiplier: 1,
                constant: 0
            )
        )
    }
    
//    var screenshot: UIImage? {
//        let size = layer.frame.size
//        guard size != .zero else { return nil }
//        return UIGraphicsImageRenderer(size: layer.frame.size).image { context in
//            layer.render(in: context.cgContext)
//        }
//    }
    
    func snapshotImage() -> UIImage? {
            // 获取视图的当前大小
            let size = bounds.size
            
        xLog("layer\(layer.frame.size)bouce\(size)")
            // 使用 UIGraphicsImageRenderer 创建图像渲染器
            let renderer = UIGraphicsImageRenderer(size: size)
            
            // 渲染视图并返回图像
            let image = renderer.image { ctx in
                layer.render(in: ctx.cgContext)
            }
            
            return image
        }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while let responder = parentResponder {
            parentResponder = responder.next
            if let viewController = responder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

extension UIView{
    public var left : CGFloat {
        get {
            return frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    public var top : CGFloat {
        get {
            return frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    public var right : CGFloat {
        get {
            return left + width
        }
    }
    
    public var bottom : CGFloat {
        get {
            return top + height
        }
    }
    
    public var width : CGFloat {
        get {
            return frame.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    public var height : CGFloat {
        get {
            return frame.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    public var centerX : CGFloat {
        get {
            return center.x
        }
        set {
            var center = self.center
            center.x = newValue
            self.center = center
        }
    }
    
    public var centerY : CGFloat {
        get {
            return center.y
        }
        set {
            var center = self.center
            center.y = newValue
            self.center = center
        }
    }
    
    public var size : CGSize {
        get {
            return CGSize(width: width, height: height)
        }
        set {
            width = newValue.width
            height = newValue.height
        }
    }
    
    public var safeTop : CGFloat {
        get {
            if #available(iOS 15.0, *) {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    let window = windowScene.windows.first
                    return window?.safeAreaInsets.top ?? 0
                } else {
                    return 0
                }
            } else {
                return UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
            }
        }
    }
    
    public var safeBottom : CGFloat {
        get {
            if #available(iOS 15.0, *) {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    let window = windowScene.windows.first
                    return window?.safeAreaInsets.bottom ?? 0
                } else {
                    return 0
                }
            } else {
                return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
            }
        }
    }
}
