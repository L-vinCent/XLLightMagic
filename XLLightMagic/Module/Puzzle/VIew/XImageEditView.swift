//
//  XImageEditViewTest.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/21.
//

import UIKit


class XImageEditView: XBaseView {
    
    // MARK: - Properties
    //操作状态
    var operationState: Bool = false{
        didSet {
            layer.borderWidth = operationState ? 1.0 : 0.0
            layer.borderColor = operationState ? UIColor.red.cgColor : UIColor.clear.cgColor
        }
    }

    var shape : XShapes = .none
    var shapeLayer : CAShapeLayer?

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private var originalImageSize: CGSize = .zero
    private var lastScale: CGFloat = 1.0
    private var lastLocation: CGPoint = .zero
    private var layoutFlag:Bool = false
    
    var image:UIImage?
//    {
//        didSet{
//            guard let img = image else  { return}
//            imageView.image = image
//            originalImageSize = img.size
//            updateImageViewFrame()
//        }
//    }
  
    // MARK: - Initializer
    
    override init() {
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(with image: UIImage?, shape: XShapes = .none) {
        self.init()
        self.image = image
        self.shape = shape
        self.layoutFlag = false
        setEidtImage(image: image)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        if(!self.layoutFlag){
//            self.layoutFlag = true
//            updateImageViewFrame()
//        }
//        let ratio = frame.width
        layoutFitView(image: self.image)
        
        switch shape {
        case .none:
            return
        case .rectangle:
            return
        case .circle:
            // 创建一个圆形路径
            let radius = min(bounds.width, bounds.height) / 2
            let center = CGPoint(x: bounds.midX, y: bounds.midY)
            let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            
            // 创建一个形状图层，并设置路径
            shapeLayer = CAShapeLayer()
            shapeLayer!.path = path.cgPath
            
            // 设置视图的遮罩为形状图层
//            layer.mask = shapeLayer
        case let .custom(points):
            // 创建一个不规则的四边形路径
            let path = UIBezierPath()
            for (index, point) in points.enumerated() {
                if index == 0 {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
            }
            path.close()
            
            // 创建一个形状图层，并设置路径
            shapeLayer = CAShapeLayer()
            shapeLayer!.path = path.cgPath
            
            // 设置视图的遮罩为形状图层
//            layer.mask = shapeLayer

        }
    }
    func layoutFitView(image:UIImage?){
        
        // 获取图片的宽高比例
         guard let cgImage = image?.cgImage else { return }
           let aspectRatio = CGFloat(cgImage.width) / CGFloat(cgImage.height)
          // 根据图片的宽高比例和父视图的大小，确定 imageView 应该被放置的大小
          let parentAspectRatio = frame.width / frame.height
          var width: CGFloat
          var height: CGFloat
          
          if aspectRatio > parentAspectRatio {
              // 图片的宽度比父视图的宽度更大
              height = frame.height
              width = height * aspectRatio
          } else {
              // 图片的高度比父视图的高度更大，或者宽高相等
              width = frame.width
              height = width / aspectRatio
          }
          // 添加约束，将 imageView 放置在父视图中心，并保持大小适应父视图
          imageView.snp.makeConstraints {
              $0.center.equalToSuperview()
              $0.width.equalTo(width)
              $0.height.equalTo(height)
          }
    }
    
    func setEidtImage(image:UIImage?){
        guard let image = image else {return}
        imageView.image = image
        originalImageSize = image.size
        
    }
    
    override func configUI() {
        super.configUI()
        self.backgroundColor = .white
        self.layer.masksToBounds = true
        self.isUserInteractionEnabled = true
        addSubview(imageView)

        
        
//        // 添加双击手势识别器
//        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
//        doubleTapGesture.numberOfTapsRequired = 2
//        imageView.addGestureRecognizer(doubleTapGesture)
//        
//        // 添加捏合手势识别器
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        imageView.addGestureRecognizer(pinchGesture)
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        imageView.addGestureRecognizer(rotationGesture)

        // 添加拖拽手势识别器
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        imageView.addGestureRecognizer(panGesture)
        //
        // 添加旋转手势识别器
        pinchGesture.delegate=self
        rotationGesture.delegate=self
        panGesture.delegate=self
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard operationState else {return nil}
        return imageView
    }
    // MARK: - Gesture Recognizers
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            let scale: CGFloat = imageView.frame.width > frame.width ? 1.0 : 2.0
            zoom(toScale: scale, center: gesture.location(in: imageView))
        }
    }
    
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
    
    @objc private func handleRotation(_ gesture: UIRotationGestureRecognizer) {
        guard let view = gesture.view else { return }
        
        if gesture.state == .began || gesture.state == .changed {
            view.transform = view.transform.rotated(by: gesture.rotation)
            gesture.rotation = 0
        }
    }

    // MARK: - Private Methods
    
    private func zoom(toScale scale: CGFloat, center: CGPoint) {
        UIView.animate(withDuration: 0.3) {
            self.imageView.transform = self.imageView.transform.scaledBy(x: scale, y: scale)
        }
        lastScale = scale
    }
    
//     func updateImageViewFrame() {
//
//        guard let image = self.image else {return}
//        let widthScale = frame.width / image.size.width
//        let heightScale = frame.height / image.size.height
//        let minScale = min(widthScale, heightScale)
//        imageView.frame.size = CGSize(width: image.size.width * minScale, height: image.size.height * minScale)
//        imageView.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
//        lastScale = minScale
////        overlayView.frame = bounds
//    }
    
}

extension XImageEditView:UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
