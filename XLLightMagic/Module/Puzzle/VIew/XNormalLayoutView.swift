//
//  XNormalLayoutView.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/24.
//

import UIKit
import HandyJSON
//import SnapKit

class XNormalLayoutView: XBaseEditView {
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
            for (index, image) in images.enumerated(){

                
            }
        }
    }
    
    // 边框图片
//    override var frameImage : UIImage? {
//        didSet {
//            frameImageView.image = frameImage
//        }
//    }
    
 
    
  
//    private lazy var frameImageView : UIImageView = {
//        let imageView = UIImageView()
//        return imageView
//    }()
    
    override func configUI() {
        super.configUI()
//        contentView.addSubview(stackView)
    }
    
    func resetViewByStyle(template:XTemplateModel?){
        
        guard let _ = template else { return }
        guard let items = template?.layer?.layerList else {return}
        for (index,item) in items.enumerated(){
            guard let image = self.images?[index] else {return}
            let editView = XImageEditView(with: image)
            addSubview(editView)
            xLog(self.frame)
            
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
