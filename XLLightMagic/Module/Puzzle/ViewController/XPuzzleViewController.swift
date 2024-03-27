//
//  XPuzzleViewController.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/21.
//

import Foundation
import UIKit

class XPuzzleViewController:XBaseViewController{
    

//    public var puzzleImages:[UIImage]?
    lazy var yellowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Yellow Button", for: .normal)
        button.backgroundColor = .yellow
        button.addTarget(self, action: #selector(yellowButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    public var editInfo:XEditInfo
    
    private lazy var contentView: XEditContainerView = {
        let view = XEditContainerView(editView: self.editView,editInfo: self.editInfo)
        view.backgroundColor = .gray
        return view
    }()

    private lazy var editView: XNormalLayoutView = {
        let view = XNormalLayoutView(images: editInfo.images)
        view.editImageModeDidChange = {[weak self] mode in
            self?.editInfo.editMode = mode
        }
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
        
        let styleName = "number_three_style_3"
        guard let tempate = XTemplateTools.loadJSONAsTemplate(jsonName: styleName) else {return}
        self.editView.template = tempate
        
    }
    
    init(editInfo: XEditInfo) {
        self.editInfo = editInfo
        super.init(nibName: nil, bundle: nil)
    }
                        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
                
    
    
    
    override func configUI() {
        
        view.addSubview(self.contentView)
        view.addSubview(self.boardListView)
        contentView.addSubview(self.editView)
        view.addSubview(yellowButton)
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(self.view.xsnp.edges).priority(.low)
            $0.top.equalToSuperview()
        }
        boardListView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-UIDevice.xp_safeDistanceBottom())
            make.height.equalTo(50)
        }
        //默认按1:1的比例初始化
        let proportion = editInfo.proportion
        editView.snp.makeConstraints {
            $0.center.equalToSuperview() // 将 editView 放置在父视图中心
            $0.width.equalTo(contentView.snp.width) // 设置 editView 的高度与父视图相同
            $0.height.equalTo(contentView.snp.width).multipliedBy(proportion.toRadio()) // 设置 editView 的宽度为父视图高度的3/4
        }
        
        yellowButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 80, height: 35))
            make.top.equalToSuperview()
            make.right.equalToSuperview()
        }
        
    }
    
    // 点击事件处理方法
      @objc func yellowButtonTapped() {
          print("Yellow Button Tapped!")
          if let view = self.editView.snapshotImage(){
              photoSave(image: view)
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
extension XPuzzleViewController{
    
//    func pickImages(callback: ( ([UIImage], [PHAsset], Bool) -> Void )?) {
//        let ps = ZLPhotoPreviewSheet()
//        ps.selectImageBlock = callback
//        ps.showPreview(animate: true, sender: self)
//    }
    
    
    /// 保存图片到相册
    /// - Parameter image: 需要保存的图片
    func photoSave(image:UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func imageSaved(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // 图片保存失败
//            view.showToast("保存图片到相册失败: \(error.localizedDescription)")
            xLog("保存图片到相册失败\(error.localizedDescription)")
            XHUD.showText("保存图片到相册失败")
        } else {
            // 图片保存成功
            xLog("图片保存成功")
//            view.showToast("图片保存成功")
//            XHUD.showSuccess("图片保存成功")
            XHUD.showText("保存图片到相册失败")

        }
    }
    
}
