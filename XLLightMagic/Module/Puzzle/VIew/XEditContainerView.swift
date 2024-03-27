//
//  XEditContainerView.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/27.
//

import UIKit

//编辑的父视图容器
class XEditContainerView:UIView{
        
     var editView:UIView?
     var editInfo:XEditInfo?

    convenience init(editView:UIView,editInfo:XEditInfo?) {
        self.init(frame: .zero)
        self.editView = editView
        self.editInfo = editInfo
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = editView,let info = editInfo else{
            //没值，正常走响应链方法透传给子视图
            return super.hitTest(point, with: event)
        }
        if(info.editMode == .fullImageEditing){
            //如果是整图编辑模式，视图不需要向下传递，直接给入参视图
            return view
        }else{
            //选中了某个小图，需要把事件传递到子视图的hitTest
            return super.hitTest(point, with: event)
        }

        
        
    }
}
