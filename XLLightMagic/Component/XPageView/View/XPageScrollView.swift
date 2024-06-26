//
//  XPageScrollView.swift
//  XLLightMagic
//
//  Created by admin on 2024/4/1.
//

import UIKit

public class XPageScrollView: UIScrollView, UIGestureRecognizerDelegate {
    
    /** 如果XPageView 与 XPageLayout结合使用 需要将它设置为true */
    @objc public var isSimpeMix = false
    
    @objc public var gestureRecognizerEnabledHandle: ((Bool) -> Void)?
    
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        guard let gestureView = gestureRecognizer.view else { return gestureBeginRet(true) }
       
        guard isSimpeMix else {  return gestureBeginRet(true)  }
        
        guard gestureRecognizer.isKind(of: NSClassFromString("UIScrollViewPanGestureRecognizer")!) else {
            return gestureBeginRet(true)
        }
        
        let velocityX = (gestureRecognizer as! UIPanGestureRecognizer).velocity(in: gestureView).x
        
        if velocityX > 0 { // 右滑
            if self.contentOffset.x == 0 {
                return gestureBeginRet(false)
            }
        }else if velocityX < 0 {// 左滑
            if self.contentOffset.x + self.width == self.contentSize.width {
                return gestureBeginRet(false)
            }
        }
        
        return gestureBeginRet(true)
    }
    
    private func gestureBeginRet(_ isEnabled: Bool) -> Bool {
        gestureRecognizerEnabledHandle?(isEnabled)
        return isEnabled
    }
    
}
