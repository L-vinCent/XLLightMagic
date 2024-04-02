//
//  XHomeBaseCell.swift
//  XLLightMagic
//
//  Created by admin on 2024/4/2.
//

import Foundation
import UIKit

class XHomeBaseCell:XBaseTableViewCell{
        
    //边距
    lazy var myContentView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.fontWhiteColor.withAlphaComponent(0.1)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var arrowIcon:UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "icon_home_arrow_right")
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        
    }
    
    override func configUI() {
        addSubview(myContentView)
        self.sendSubviewToBack(myContentView)

        myContentView.addSubview(arrowIcon)
        
        myContentView.snp.makeConstraints { make in
            make.edges.equalTo(self.xsnp.edges).offset(15).priority(.low)
            make.right.equalTo(self.snp_right).offset(-15)
            make.bottom.equalTo(self.snp_bottom)
        }
        
        arrowIcon.snp.makeConstraints { make in
            make.size.equalTo(CGSizeMake(24, 24))
            make.centerY.equalTo(myContentView.snp_centerY)
            make.right.equalTo(myContentView.snp_right).offset(-10)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
}
