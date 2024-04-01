//
//  XScrollExtension.swift
//  XLLightMagic
//
//  Created by admin on 2024/4/1.
//

import Foundation
import UIKit

extension UIScrollView {
    
    public typealias XScrollHandle = (UIScrollView) -> Void
    
    private struct XHandleKey {
        static var key :Void?
        static var tKey :Void?
    }
    
    public var scrollHandle: XScrollHandle? {
        get { return objc_getAssociatedObject(self, &XHandleKey.key) as? XScrollHandle }
        set { objc_setAssociatedObject(self, &XHandleKey.key, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }
    
    @objc public var isTableViewPlain: Bool {
        get { return (objc_getAssociatedObject(self, &XHandleKey.tKey) as? Bool) ?? false}
        set { objc_setAssociatedObject(self, &XHandleKey.tKey, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
}

extension String {
    func x_base64Decoding() -> String {
        let decodeData = NSData.init(base64Encoded: self, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        if decodeData == nil || decodeData?.length == 0 {
            return "";
        }
        let decodeString = NSString(data: decodeData! as Data, encoding: String.Encoding.utf8.rawValue)
        return decodeString! as String
    }
}

extension UIScrollView {
    
    public class func initializeOnce() {
        
        DispatchQueue.once(token: UIDevice.current.identifierForVendor?.uuidString ?? "XScrollView") {
            let didScroll = "X25vdGlmeURpZFNjcm9sbA==".x_base64Decoding()
            let originSelector = Selector((didScroll))
            let swizzleSelector = #selector(x_scrollViewDidScroll)
            x_swizzleMethod(self, originSelector, swizzleSelector)
        }
        
    }
    
    @objc dynamic func x_scrollViewDidScroll() {
        self.x_scrollViewDidScroll()
        guard let scrollHandle = scrollHandle else { return }
        scrollHandle(self)
    }
}

extension NSObject {
    
    static func x_swizzleMethod(_ cls: AnyClass?, _ originSelector: Selector, _ swizzleSelector: Selector)  {
        let originMethod = class_getInstanceMethod(cls, originSelector)
        let swizzleMethod = class_getInstanceMethod(cls, swizzleSelector)
        guard let swMethod = swizzleMethod, let oMethod = originMethod else { return }
        let didAddSuccess: Bool = class_addMethod(cls, originSelector, method_getImplementation(swMethod), method_getTypeEncoding(swMethod))
        if didAddSuccess {
            class_replaceMethod(cls, swizzleSelector, method_getImplementation(oMethod), method_getTypeEncoding(oMethod))
        } else {
            method_exchangeImplementations(oMethod, swMethod)
        }
    }
}
