//
//  newtest.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/27.
//

import UIKit

class DraggableView: UIView {
    // 记录触摸点在视图内的偏移量
    private var touchOffset: CGPoint = .zero
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        self.backgroundColor = .blue
        setupGestureRecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGestureRecognizer()
    }
    
    // 添加拖动手势识别器
    private func setupGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(panGesture)
    }
    
    // 拖动手势处理方法
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            // 计算触摸点在视图内的偏移量
            let touchPoint = gesture.location(in: self)
            touchOffset = CGPoint(x: touchPoint.x - bounds.midX, y: touchPoint.y - bounds.midY)
        case .changed:
            // 计算新的视图位置
            let translation = gesture.translation(in: superview)
            let newCenter = CGPoint(x: center.x + translation.x, y: center.y + translation.y)
            center = newCenter
            gesture.setTranslation(.zero, in: superview)
        default:
            break
        }
    }
}
