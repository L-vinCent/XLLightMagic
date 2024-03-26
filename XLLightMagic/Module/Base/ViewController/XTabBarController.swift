//
//  XTabbarController.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/20.
//

import Foundation
import UIKit

class XTabBarController:UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
        
        let mineVC = TestVC()
        addChildViewController(mineVC,
                               title: "测试Tab",
                               image: UIImage(named: "tab_mine"),
                               selectedImage: UIImage(named: "tab_mine_S"))
        
    }
   
    
    
    func addChildViewController(_ childController: UIViewController, title:String?, image:UIImage? ,selectedImage:UIImage?) {
        
        childController.title = title
        childController.tabBarItem = UITabBarItem(title: nil,
                                                  image: image?.withRenderingMode(.alwaysOriginal),
                                                  selectedImage: selectedImage?.withRenderingMode(.alwaysOriginal))
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            childController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
        
        addChild(UNavigationController(rootViewController: childController))
    }
    
}


extension XTabBarController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let select = selectedViewController else { return .lightContent }
        return select.preferredStatusBarStyle
    }
}
