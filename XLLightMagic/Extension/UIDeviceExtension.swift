//
//  UIDevice+Extension.swift
//  U17
//
//  Created by charles on 2017/10/27.
//  Copyright © 2017年 None. All rights reserved.
//

import Foundation
import UIKit

public extension UIDevice {
  
    //app版本号
    static var appVersion: String? {
           return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
       }
    
}

public extension UIDevice{
    /// 顶部安全区高度
       static func xd_safeDistanceTop() -> CGFloat {
           if #available(iOS 13.0, *) {
               let scene = UIApplication.shared.connectedScenes.first
               guard let windowScene = scene as? UIWindowScene else { return 0 }
               guard let window = windowScene.windows.first else { return 0 }
               return window.safeAreaInsets.top
           } else {
               guard let window = UIApplication.shared.windows.first else { return 0 }
               return window.safeAreaInsets.top
           }
       }
       
       /// 底部安全区高度
       static func xp_safeDistanceBottom() -> CGFloat {
           if #available(iOS 13.0, *) {
               let scene = UIApplication.shared.connectedScenes.first
               guard let windowScene = scene as? UIWindowScene else { return 0 }
               guard let window = windowScene.windows.first else { return 0 }
               return window.safeAreaInsets.bottom
           } else {
               guard let window = UIApplication.shared.windows.first else { return 0 }
               return window.safeAreaInsets.bottom
           }
       }
       
       /// 顶部状态栏高度（包括安全区）
       static func xp_statusBarHeight() -> CGFloat {
           var statusBarHeight: CGFloat = 0
           if #available(iOS 13.0, *) {
               let scene = UIApplication.shared.connectedScenes.first
               guard let windowScene = scene as? UIWindowScene else { return 0 }
               guard let statusBarManager = windowScene.statusBarManager else { return 0 }
               statusBarHeight = statusBarManager.statusBarFrame.height
           } else {
               statusBarHeight = UIApplication.shared.statusBarFrame.height
           }
           return statusBarHeight
       }
       
       /// 导航栏高度
       static func xp_navigationBarHeight() -> CGFloat {
           return 44.0
       }
       
       /// 状态栏+导航栏的高度
       static func xp_navigationFullHeight() -> CGFloat {
           return UIDevice.xp_statusBarHeight() + UIDevice.xp_navigationBarHeight()
       }
       
       /// 底部导航栏高度
       static func xp_tabBarHeight() -> CGFloat {
           return 49.0
       }
       
       /// 底部导航栏高度（包括安全区）
       static func xp_tabBarFullHeight() -> CGFloat {
           return UIDevice.xp_tabBarHeight() + UIDevice.xp_safeDistanceBottom()
       }
}

public extension UIDevice{
//    func getWindow() -> UIWindow? {
//        if #available(iOS 13.0, *) {
//            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//               let window = scene.windows.first {
//                return window
//            }
//        } else {
//            if let window = UIApplication.shared.windows.first {
//                return window
//            }
//        }
//        return nil
//    }
    
   static func keyWindow() -> UIWindow?{
        if #available(iOS 13, *) {
             return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })
            
        } else {
            return  UIApplication.shared.keyWindow
        }
    }
   
    
    
}
