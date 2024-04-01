//
//  XPageVCExtention.swift
//  XLLightMagic
//
//  Created by admin on 2024/4/1.
//

import Foundation
import UIKit
extension UIViewController {
    
    private struct LTVCKey {
        static var sKey : Void?
        static var oKey : Void?
    }
    
    @objc public var glt_scrollView: UIScrollView? {
        get { return objc_getAssociatedObject(self, &LTVCKey.sKey) as? UIScrollView }
        set { objc_setAssociatedObject(self, &LTVCKey.sKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    public var glt_upOffset: String? {
        get { return objc_getAssociatedObject(self, &LTVCKey.oKey) as? String }
        set { objc_setAssociatedObject(self, &LTVCKey.oKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

