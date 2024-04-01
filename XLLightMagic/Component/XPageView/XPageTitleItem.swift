//
//  XPageTitleItem.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/29.
//

import UIKit

//enum XAssociatedKeys {
//    static var x_isSelected = "x_isSelected"
//}
private struct AssociatedKeys {
    static var x_isSelected: Void?
}

@objc public protocol XPageTitleItem where Self:UIButton{
    
    
    /// 当前选中、取消选中的索引
    @objc var x_index: Int { get set }
    
    /// 可选实现 - 首次设置frame以后，frame的值, 此方法仅会调用一次
    /// layoutSubviews中的frame会跟随放大效果改变，故此方法为初次设置后的frame
    @objc optional
    func x_layoutSubviews()
    
    /// 可选实现 - 可在此方法内部进行未选中后的一些处理
    @objc optional
    func x_unselected()
    
    /// 可选实现 - 可在此方法内部进行选中后的一些处理
    @objc optional
    func x_selected()
    
    /// 可选实现 - 合并成一个方法，进行选中和未选中的处理
    @objc optional
    func x_setSelected(_ isSelected: Bool)
  
}

public extension XPageTitleItem {
    
    /// 当前选中以及取消选中
    var x_isSelected: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.x_isSelected) as? Bool ?? false
        }
        set {
            let _isSelected = newValue
            objc_setAssociatedObject(self, &AssociatedKeys.x_isSelected, _isSelected, .OBJC_ASSOCIATION_ASSIGN)
            _isSelected ? x_selected?() : x_unselected?()
            x_setSelected?(_isSelected)
        }
    }
}
