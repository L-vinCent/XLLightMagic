//
//  XImageEditView.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/21.
//

import UIKit

// 定义 XImageEditViewDelegate 协议
protocol XImageEditViewDelegate: AnyObject {
    func tapWithEditView(_ sender: XTestImageEditView)
}

// 定义 XImageEditView 类，并继承自 UIScrollView，并遵循 UIScrollViewDelegate 协议
class XTestImageEditView: UIScrollView {
    
    // MARK: - Properties
    
    // 懒加载初始化 contentView
    private lazy var contentView: UIScrollView = {
        let scrollView = UIScrollView(frame: bounds.insetBy(dx: 0, dy: 0))
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    // 懒加载初始化 imageview
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: bounds)
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .blue
        return imageView
    }()
    
    var realCellArea: UIBezierPath?
    weak var tapDelegate: XImageEditViewDelegate?
    var oldRect: CGRect = .zero
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initImageView()
    }
    
    // MARK: - Private Methods
    
    private func initImageView() {
        backgroundColor = .gray
        
        addSubview(contentView)
        contentView.addSubview(imageView)
        
        // 双击手势放大图片
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTapGesture)
        
        let minimumScale = frame.size.width / imageView.frame.size.width
        contentView.minimumZoomScale = 0.1
        contentView.zoomScale = minimumScale
    }
    
    // 设置图片数据及位置
    func setImageViewData(_ imageData: UIImage, rect: CGRect) {
        self.frame = rect
        setImageViewData(imageData)
    }
    
    // 设置图片数据
    func setImageViewData(_ imageData: UIImage) {
        imageView.image = imageData
        
        guard let imageData = imageData.cgImage else { return }
        
        var rect = CGRect.zero
        var scale: CGFloat = 1.0
        var w: CGFloat = 0.0
        var h: CGFloat = 0.0
        
        if contentView.frame.size.width > contentView.frame.size.height {
            w = contentView.frame.size.width
            h = w * CGFloat(imageData.height) / CGFloat(imageData.width)
            if h < contentView.frame.size.height {
                h = contentView.frame.size.height
                w = h * CGFloat(imageData.width) / CGFloat(imageData.height)
            }
        } else {
            h = contentView.frame.size.height
            w = h * CGFloat(imageData.width) / CGFloat(imageData.height)
            if w < contentView.frame.size.width {
                w = contentView.frame.size.width
                h = w * CGFloat(imageData.height) / CGFloat(imageData.width)
            }
        }
        rect.size = CGSize(width: w, height: h)
        
        let scale_w = w / CGFloat(imageData.width)
        let scale_h = h / CGFloat(imageData.height)
        
        if w > self.frame.size.width || h > self.frame.size.height {
            let scale = max(scale_w, scale_h)
            self.imageView.frame = rect
//            let maskLayer = CAShapeLayer()
//            maskLayer.path = realCellArea?.cgPath
//            maskLayer.fillColor = UIColor.white.cgColor
//            maskLayer.frame = imageView.frame
//            layer.mask = maskLayer
            contentView.setZoomScale(0.2, animated: true)
            

            setNeedsLayout()
        }
    }
    
    // 双击手势处理
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        let newScale = contentView.zoomScale * 1.2
        let zoomRect = zoomRectForScale(scale: newScale, withCenter: gesture.location(in: imageView))
        contentView.zoom(to: zoomRect, animated: true)
    }
    
    // 计算放大的区域
    private func zoomRectForScale(scale: CGFloat, withCenter center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = frame.size.height / scale
        zoomRect.size.width = frame.size.width / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
}

// MARK: - UIScrollViewDelegate

extension XTestImageEditView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
