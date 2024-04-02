//
//  XMineViewController.swift
//  XLLightMagic
//
//  Created by admin on 2024/4/2.
//

import Foundation
import UIKit
class XMineViewController:XBaseViewController{
    
    private lazy var myArray: Array = {
        return [
            ["title":"意见反馈"],
            ["title":"版本号"],
            ["title":"检查更新"],
            ["title":"隐私政策"],
            ["title":"用户协议"],
        ]
    }()
    
//    lazy var tableView: UITableView = {
//        let tw = UITableView(frame: .zero, style: .plain)
//        tw.backgroundColor = UIColor.themeBackground
//        tw.delegate = self
//        tw.dataSource = self
//        tw.register(cellType: UBaseTableViewCell.self)
//        return tw
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func configUI() {
        
    }
    
    
}
