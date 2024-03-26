//
//  XPuzzleViewController.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/21.
//

import Foundation
import UIKit

class XPuzzleViewController:XBaseViewController{
    

    public var puzzleImages:[UIImage]?
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    private lazy var editView: XNormalLayoutView = {
        let view = XNormalLayoutView(images: self.puzzleImages)
        
        return view
    }()
    
    private lazy var boardListView:XBoardListView = {
        let view = XBoardListView()
        let imageNameArray = [
            "makecards_puzzle_storyboard1_icon",
            "makecards_puzzle_storyboard2_icon",
            "makecards_puzzle_storyboard3_icon",
            "makecards_puzzle_storyboard4_icon",
            "makecards_puzzle_storyboard5_icon",
            "makecards_puzzle_storyboard6_icon"
        ]
        view.imageArray = imageNameArray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化 XImageEditView
        
        
        let styleName = "number_three_style_3"
        guard let tempate = XTemplateManager.loadJSONAsTemplate(jsonName: styleName) else {return}
//        guard let ratioH = tempate.ratioH,
//              let ratioW = tempate.ratioW else { return }
//        let size = calculateEditViewSize(ratioW: ratioW, ratioH: ratioH)
        self.editView.template = tempate
        
    }
    
    override func configUI() {
        
        view.addSubview(self.contentView)
        view.addSubview(self.boardListView)
        contentView.addSubview(self.editView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(self.view.xsnp.edges).priority(.low)
            $0.top.equalToSuperview()
        }
        boardListView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-UIDevice.xp_safeDistanceBottom())
            make.height.equalTo(50)
        }
        //默认按3:4的比例初始化
        editView.snp.makeConstraints {
            $0.center.equalToSuperview() // 将 editView 放置在父视图中心
            $0.width.equalTo(contentView.snp.width) // 设置 editView 的高度与父视图相同
            $0.height.equalTo(contentView.snp.width).multipliedBy(4.0 / 3.0) // 设置 editView 的宽度为父视图高度的3/4
        }
        
    }
    
    
}

//frame处理
extension XPuzzleViewController{
    //计算layoutView的frame
    func calculateEditViewSize(ratioW:Int?,ratioH:Int?) -> CGSize {
        let parentView = self.editView.superview
        guard let size = parentView?.frame.size else {return .zero}
        guard let ratioW = ratioW, let ratioH = ratioH else {
            return .zero // 如果ratioW或ratioH为空，则返回zero size
        }
        let width: CGFloat
        let height: CGFloat
        if ratioW > ratioH { // 长比宽大，长铺满
            width = size.width
            height = width * CGFloat(ratioH) / CGFloat(ratioW)
        } else { // 宽比长大或者长宽相等，宽铺满
            height = size.height
            width = height * CGFloat(ratioW) / CGFloat(ratioH)
        }
        return CGSize(width: width, height: height)
    }

}
extension XPuzzleViewController:XImageEditViewDelegate{
    
    func tapWithEditView(_ sender: XTestImageEditView) {
        
    }
    
}