//
//  UIViewFrameExtension.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/24.
//

import UIKit


extension UIView {
    
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

