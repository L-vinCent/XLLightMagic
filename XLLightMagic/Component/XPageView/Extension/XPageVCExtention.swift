//
//  XPageVCExtention.swift
//  XLLightMagic
//
//  Created by admin on 2024/4/1.
//

import Foundation
import UIKit
extension UIViewController {
    
    private struct XVCKey {
        static var sKey : Void?
        static var oKey : Void?
    }
    
    @objc public var x_scrollView: UIScrollView? {
        get { return objc_getAssociatedObject(self, &XVCKey.sKey) as? UIScrollView }
        set { objc_setAssociatedObject(self, &XVCKey.sKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    public var x_upOffset: String? {
        get { return objc_getAssociatedObject(self, &XVCKey.oKey) as? String }
        set { objc_setAssociatedObject(self, &XVCKey.oKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

