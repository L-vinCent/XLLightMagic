//
//  XSettingCell.swift
//  XLLightMagic
//
//  Created by admin on 2024/4/2.
//

import UIKit
class XSettingCell:XBaseTableViewCell{
    
    var title:String?{
        didSet{
            myLabel.text = title ?? ""
        }
    }
    
    var subTitle:String?{
        didSet{
            mySubLabel.text = subTitle ?? ""
        }
    }
    
    lazy var myLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.regularFont
        label.textColor = UIColor.fontWhiteColor
        return label
    }()
    
    lazy var mySubLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.regularFont
        label.textColor = UIColor.fontGray600
        label.textAlignment = .right
        return label
    }()
    
    lazy var arrowIcon:UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "icon_home_arrow_right")
        return view
    }()
    
    lazy var lineView:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fontWhiteColor.withAlphaComponent(0.1)
        return v;
    }()
    
    
    override func configUI() {
        self.backgroundColor = UIColor.themeBackground
        addSubview(myLabel)
        addSubview(mySubLabel)
        addSubview(arrowIcon)
        addSubview(lineView)
        
        myLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: 100, height: 20))
        }
        
        mySubLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-36)
            make.size.equalTo(CGSize(width: 100, height: 20))
        }
        
        arrowIcon.snp.makeConstraints { make in
            make.size.equalTo(CGSizeMake(16, 16))
            make.centerY.equalTo(self.snp_centerY)
            make.right.equalTo(self.snp_right).offset(-20)
        }
        
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-1)
            make.height.equalTo(1)
        }
    }
}
