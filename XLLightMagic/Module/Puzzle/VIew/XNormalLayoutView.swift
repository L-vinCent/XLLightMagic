//
//  XNormalLayoutView.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/24.
//

import UIKit
import HandyJSON
//import SnapKit

enum EditMode {
    case fullImageEditing //整图缩放
    case singleImageEditing //小图缩放
}

class XNormalLayoutView: XBaseEditView {
    private var xImageEditViews: [XImageEditView] = []
    private var lastLocation: CGPoint = .zero
    private var editMode: EditMode = .fullImageEditing

    var template:XTemplateModel?{
        didSet{
            guard let template = template else {return}
            layoutIfNeeded()
            xLog(self.frame)
            resetViewByStyle(template: template)
        }
    }
    
    override var images: [UIImage]? {
        didSet {
            print("image did set")
            guard let images = images else { return}
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
        } else if gesture.state == .changed {
            let translation = gesture.translation(in: self)
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
                }else{
                    xImageEditView.operationState = true
                    anyViewSelected = true
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

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        if(touch.tapCount == 1){
//            xLog("单指点击了")
//        }
//        let touchPoint = touch.location(in: self)
//        
//        for xImageEditView in xImageEditViews {
//            let convertedPoint = xImageEditView.convert(touchPoint, from: self)
//            if xImageEditView.bounds.contains(convertedPoint) {
//                // 点击范围内的 xImageEditView，将其 operationState 设置为 true
//                xImageEditView.operationState = true
//            } else {
//                // 不在点击范围内的 xImageEditView，将其 operationState 设置为 false
//                xImageEditView.operationState = false
//            }
//        }
//        
//       let v = hitTest(touchPoint, with: event)
//        
//    }

    
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
    func rectWithArray(_ array: [String], andSuperSize superSize: CGSize) -> CGRect {
        var rect = CGRect.zero
        var minX = CGFloat.greatestFiniteMagnitude
        var maxX: CGFloat = 0
        var minY = CGFloat.greatestFiniteMagnitude
        var maxY: CGFloat = 0
        
        for pointString in array {
            let point = NSCoder.cgPoint(for: pointString)
            if point.x <= minX {
                minX = point.x
            }
            
            if point.x >= maxX {
                maxX = point.x
            }
            
            if point.y <= minY {
                minY = point.y
            }
            
            if point.y >= maxY {
                maxY = point.y
            }
            
            rect = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
        }
        
        rect = rectScaleWithRect(rect, scale: 2.0)
        rect.origin.x = rect.origin.x * frame.size.width / superSize.width
        rect.origin.y = rect.origin.y * frame.size.height / superSize.height
        rect.size.width = rect.size.width * frame.size.width / superSize.width
        rect.size.height = rect.size.height * frame.size.height / superSize.height
        
        return rect
    }

    func rectScaleWithRect(_ rect: CGRect, scale: CGFloat) -> CGRect {
        var retRect = CGRect.zero
        
        let newScale = max(scale, 1.0)
        retRect.origin.x = rect.origin.x / newScale
        retRect.origin.y = rect.origin.y / newScale
        retRect.size.width = rect.size.width / newScale
        retRect.size.height = rect.size.height / newScale
        
        return retRect
    }

    func pointScaleWithPoint(_ point: CGPoint, scale: CGFloat) -> CGPoint {
        let newScale = max(scale, 1.0)
        return CGPoint(x: point.x / newScale, y: point.y / newScale)
    }

    func sizeScaleWithSize(_ size: CGSize, scale: CGFloat) -> CGSize {
        let newScale = max(scale, 1.0)
        return CGSize(width: size.width / newScale, height: size.height / newScale)
    }
}


extension XNormalLayoutView:UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
