//
//  TestVC.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/20.
//

import UIKit
import ZLPhotoBrowser
class TestVC:XBaseViewController {
    
    private lazy var xArray:Array = {
        return [
            ["title":"拼图测试"],
            ["title":"选择照片"],
        ]
    }()
    
    lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .grouped)
        tw.backgroundColor = UIColor.background
        tw.delegate = self
        tw.dataSource = self
        tw.register(cellType: XBaseTableViewCell.self)
        return tw
    }()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
    }
    
    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.xsnp.edges).priority(.low)
            $0.top.equalToSuperview()
        }
        
    }
    
    func loadData(){
        
        ApiLoadingProvider.request(XApi.chapter(chapter_id: 20), model: ChapterModel.self) { (returnData) in
            xLog("测试数据\(returnData)")
        }
        
    }
}

extension TestVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return xArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: XBaseTableViewCell.self)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .default
        let dict: [String: String] = xArray[indexPath.row]
        cell.textLabel?.text = dict["title"]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        if(indexPath.row==0){
//            let puzzleVC = XPuzzleViewController()
//            navigationController?.pushViewController(puzzleVC, animated: false)
//        }
        if(indexPath.row==1){
            let config = ZLPhotoConfiguration.default()
            config.allowMixSelect = false
            config.allowEditVideo = false
            config.allowSelectVideo = false

            let ps = ZLPhotoPreviewSheet()
            ps.selectImageBlock = {[weak self] results,isOriginal in
                guard let self = self else {return}
                
                xLog("\(isOriginal)")
                let images = results.map{ $0.image }
                
                let puzzleVC = XPuzzleViewController(editInfo: XEditInfo(images: images))
                self.navigationController?.pushViewController(puzzleVC, animated: false)
                
            }
            ps.showPhotoLibrary(sender: self)
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
