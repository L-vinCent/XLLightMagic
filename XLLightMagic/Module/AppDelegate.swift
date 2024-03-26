//
//  AppDelegate.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var orientation: UIInterfaceOrientationMask = .portrait


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = XTabBarController()
        window?.makeKeyAndVisible()
        
        return true
    }

   
}

