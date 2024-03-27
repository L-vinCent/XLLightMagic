//
//  XNormalLayoutView.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/24.
//

import UIKit
import HandyJSON
//import SnapKit


class XNormalLayoutView: XBaseView {
    private var xImageEditViews: [XImageEditView] = []
    private var lastLocation: CGPoint = .zero
//    private var editMode: EditMode = .fullImageEditing
    var editImageModeDidChange: ((XEditImageMode) -> Void)?
    
    
    var template:XTemplateModel?{
        didSet{
            guard let template = template else {return}
            layoutIfNeeded()
            xLog(self.frame)
            resetViewByStyle(template: template)
        }
    }
    
     var images: [UIImage]? {
        didSet {
            print("image did set")
//            guard let images = images else { return}
        }
    }
    
    lazy var pinchGesture: UIPinchGestureRecognizer = {
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        gesture.delegate = self
        return gesture
    }()

    // 懒加载平移手势识别器
    lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        gesture.delegate = self
        return gesture
    }()

    // 懒加载轻击手势识别器
    lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        return gesture
    }()
    
    override func configUI() {
        super.configUI()
        
        addGestureRecognizer(pinchGesture)
        addGestureRecognizer(panGesture)
        addGestureRecognizer(tapGesture)
        
     
    }
    
    convenience init(images:[UIImage]?) {
        self.init()
        self.images = images
//        configUI()
    }
    
    
    // MARK: - Gesture Recognizers

    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let view = gesture.view else { return }
        if gesture.state == .began || gesture.state == .changed {
            let scale = gesture.scale
            view.transform = view.transform.scaledBy(x: scale, y: scale)
            gesture.scale = 1.0
        }
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        
        if gesture.state == .began {
            
            lastLocation = view.center
            xLog("self\(self)location\(lastLocation)")
        } else if gesture.state == .changed {
            let translation = gesture.translation(in: superview)
            view.center = CGPoint(x: lastLocation.x + translation.x, y: lastLocation.y + translation.y)
        }
    }
    
    //单指点击手势，用来确认选中哪个小图
    @objc private func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        // 切换编辑模式为小图编辑
        // editMode = .singleImageEditing
        var anyViewSelected = false

        guard let tappedView = gestureRecognizer.view else { return }
        let touchPoint = gestureRecognizer.location(in: tappedView)
        
        for xImageEditView in xImageEditViews {
            let convertedPoint = xImageEditView.convert(touchPoint, from: tappedView)
            if xImageEditView.bounds.contains(convertedPoint) {
                // 点击范围内的 xImageEditView，将其 operationState 设置为 true
                if(xImageEditView.operationState){
                    xImageEditView.operationState = false
                    editImageModeDidChange?(.fullImageEditing)
                }else{
                    xImageEditView.operationState = true
                    anyViewSelected = true
                    editImageModeDidChange?(.singleImageEditing)
                }
            } else {
                // 不在点击范围内的 xImageEditView，将其 operationState 设置为 false
                xImageEditView.operationState = false
            }
        }
        
        pinchGesture.isEnabled = !anyViewSelected
        panGesture.isEnabled = !anyViewSelected
        
    }
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

        if let firstSelectedView = xImageEditViews.first(where: { $0.operationState }) {
            // 执行你需要的逻辑
            firstSelectedView.operationState = true
        }
        
        return super.hitTest(point, with: event)
        
    }

    
    //设置布局样式
    func resetViewByStyle(template:XTemplateModel?){
        
        guard let _ = template else { return }
        xImageEditViews.removeAll()
        guard let items = template?.layer?.layerList else {return}
        for (index,item) in items.enumerated(){
            guard let image = self.images?[index] else {return}
            let editView = XImageEditView(with: image)
            addSubview(editView)
            xImageEditViews.append(editView)
            
            
            let superSize = frame.size
            let originX = superSize.width * (item.rect?.left ?? 1)
            let originY = superSize.height * (item.rect?.top ?? 1)
            let width = superSize.width * (item.rect?.width ?? 1)
            let height = superSize.height * (item.rect?.height ?? 1)

            editView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(originX)
                make.top.equalToSuperview().offset(originY)
                make.size.equalTo(CGSize(width: width, height: height))
            }
            
        }
        
    }

}
extension XNormalLayoutView{
//    guard let model = JSONDeserializer<T>.deserializeFrom(json: jsonString) else {
//        throw MoyaError.jsonMapping(self)
//    }
    //功能方法封装
    
}
//frame处理
extension XNormalLayoutView{
   
}



extension XNormalLayoutView:UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
