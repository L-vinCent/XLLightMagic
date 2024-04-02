//
//  XHomePuzzleListViewController.swift
//  XLLightMagic
//
//  Created by admin on 2024/4/2.
//

import UIKit
class XHomePuzzleListViewController:XBaseViewController{
    
    private lazy var myArray: Array = {
        return [
            ["title":"多格拼图","imageName":"icon_home_puzzles"],
            ["title":"竖拼长图","imageName":"icon_home_puzzleVer"],
            ["title":"横拼长图","imageName":"icon_home_puzzleHor"],
        ]
    }()
    lazy var tableView: UITableView = {
        
        let tw = UITableView(frame: .zero, style: .plain)
        tw.backgroundColor = UIColor.themeBackground
        tw.delegate = self
        tw.dataSource = self
        tw.register(cellType: XPuzzlePageListCell.self)
        return tw
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.x_scrollView = self.tableView
    }
    override func configUI() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.xsnp.edges).priority(.low)
            $0.top.equalToSuperview().offset(44)
            $0.height.equalToSuperview().offset(-44)
        }
        
    }
    
}


extension XHomePuzzleListViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myArray.count
    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return CGFloat.leastNormalMagnitude
//    }
//
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return nil
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: XPuzzlePageListCell.self)
        cell.selectionStyle = .default
        let dict: [String: String] = myArray[indexPath.row]
        cell.iconUrl =  dict["imageName"] ?? ""
        cell.title = dict["title"] ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
