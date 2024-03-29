//
//  XHomeViewController.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/29.
//

import Foundation
import UIKit

class XHomeViewController:XBaseViewController{
    
    lazy var settingView: UIView = {
           let view = UIView()
           view.backgroundColor = UIColor.themeBackground
           view.addSubview(self.button)
           return view
       }()
       
       lazy var button: UIButton = {
           let button = UIButton()
           button.frame = CGRectMake(0, 0, 46, 46)
           button.setImage(UIImage(named: "icon_home_setting"), for: .normal)
           button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
           return button
       }()
    override func configUI() {
        view.addSubview(self.settingView)
        
        settingView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(46)
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(UIDevice.xd_safeDistanceTop())
        }
        
        
    }
    
    
    
}

extension XHomeViewController{
    
    @objc func buttonTapped() {
        print("Button tapped!")
        // 在这里添加按钮点击事件的处理代码
    }

}
