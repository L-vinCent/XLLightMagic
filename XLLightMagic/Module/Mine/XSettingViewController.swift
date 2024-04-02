//
//  XMineViewController.swift
//  XLLightMagic
//
//  Created by admin on 2024/4/2.
//

import Foundation
import UIKit
class XSettingViewController:XBaseViewController{
    
    private lazy var myArray: Array = {
        return [
            ["title":"意见反馈","subTitle":""],
            ["title":"版本号","subTitle":"\(UIDevice.appVersion ?? "")"],
            ["title":"隐私政策","subTitle":""],
            ["title":"用户协议","subTitle":""],
        ]
    }()
    
    
    lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .plain)
        tw.backgroundColor = UIColor.themeBackground
        tw.delegate = self
        tw.dataSource = self
        tw.register(cellType: XSettingCell.self)
        return tw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //导航栏点击
        self.didNavClickHandle = {[weak self] in
            guard let self = self else {return}
            self.dismiss(animated: true)
        }

    }
    override func configUI() {
        view.addSubview(self.tableView)
        let nav = addCustomNavView(title: "设置")
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.xsnp.edges).priority(.low)
            $0.top.equalTo(nav.snp_bottom)
        }
        
    }
    
    
}



extension XSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myArray.count
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: XSettingCell.self)
        let dict: [String: String] = myArray[indexPath.row]
        cell.subTitle =  dict["subTitle"] ?? ""
        cell.title = dict["title"] ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        navigationController?.pushViewController(TestVC(), animated: true)
    }
    
}
