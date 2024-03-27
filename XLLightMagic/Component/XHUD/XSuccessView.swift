//
//  XSuccessView.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/27.
//

import UIKit

enum XAnimationType :Int{
    case success
    case error
}

class XSuccessView: UIView {
    
    private var shapeLayer: CAShapeLayer?
    var animationType: XAnimationType = .success {
        didSet {
            drawSuccessErrorLine()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawSuccessErrorLine() {
        let radius = self.frame.size.width / 2
        let path = UIBezierPath()
        
        switch animationType {
        case .success:
            path.move(to: CGPoint(x: self.center.x - radius + 5, y: self.center.y))
            path.addLine(to: CGPoint(x: self.center.x - 3.0, y: self.center.y + 10.0))
            path.addLine(to: CGPoint(x: self.center.x + radius - 5, y: self.center.y - 10))
            
        case .error:
            path.move(to: CGPoint(x: radius / 2, y: radius / 2))
            path.addLine(to: CGPoint(x: radius + radius / 2, y: radius + radius / 2))
            path.move(to: CGPoint(x: radius / 2, y: radius + radius / 2))
            path.addLine(to: CGPoint(x: radius + radius / 2, y: radius / 2))
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 5.0
        shapeLayer.lineCap = .round
        shapeLayer.strokeStart = 0.0
        shapeLayer.strokeEnd = 0.0
        
        self.layer.addSublayer(shapeLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.45
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        
        shapeLayer.add(animation, forKey: "strokeEnd")
        
        // Store shapeLayer
        self.shapeLayer = shapeLayer
    }
}
