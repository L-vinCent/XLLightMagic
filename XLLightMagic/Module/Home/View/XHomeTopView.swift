//
//  XHomeTopView.swift
//  XLLightMagic
//
//  Created by admin on 2024/4/2.
//

import UIKit

typealias DidTapSettingHandle = () -> Void

class XHomeTopView:XBaseView{
    
    var didTapSettingHandle: DidTapSettingHandle?

    private lazy var iconView:UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFill
        iw.image = UIImage(named: "icon_home_logo")
        iw.clipsToBounds = true
        return iw
    }()
    
  
    lazy var button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_home_setting"), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.extendEdgeInsets = UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11)
        return button
    }()
    
    
    override func configUI() {
        self.backgroundColor = UIColor.themeBackground
        addSubview(self.iconView)
        addSubview(self.button)
        
        iconView.snp.makeConstraints { make in
            make.size.equalTo(CGSizeMake(127, 32))
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        
        
        button.snp.makeConstraints { make in
            make.size.equalTo(CGSizeMake(24, 24))
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
        
        
    }
}

extension XHomeTopView{
    
    @objc func buttonTapped() {
        print("Button tapped!")
        didTapSettingHandle?()
    }

}

