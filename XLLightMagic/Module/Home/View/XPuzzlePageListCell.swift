//
//  XPuzzlePageListCell.swift
//  XLLightMagic
//
//  Created by admin on 2024/4/2.
//

import Foundation
import UIKit
class XPuzzlePageListCell:XHomeBaseCell{
        
    var title:String?{
        didSet{
            self.myLabel.text = title ?? ""
        }
    }
    
    var iconUrl:String?{
        didSet{
            myIcon.image = UIImage(named: iconUrl ?? "")
        }
    }
  
    
    lazy var myLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.PingFangMedium(size: 18)
        label.textColor = UIColor.fontWhiteColor
        return label
    }()
    
    lazy var myIcon:UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        self.addSubview(myContentView)
        self.sendSubviewToBack(myContentView)
    }
    
    override func configUI() {
        super.configUI()
        myContentView.addSubview(myIcon)
        myContentView.addSubview(myLabel)
        
        myLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSizeMake(100, 24))
            make.centerY.equalTo(myContentView.snp_centerY)
            make.left.equalTo(myContentView.snp_left).offset(20)
        }
        
        myIcon.snp.makeConstraints { make in
            make.size.equalTo(CGSizeMake(36, 36))
            make.centerY.equalTo(myContentView.snp_centerY)
            make.right.equalTo(myContentView.snp_right).offset(-44)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
}
