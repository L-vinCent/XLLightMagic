//
//  XEditInfo.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/24.
//

import UIKit
//拼图的数据管理中心
class XEditInfo{
    //用户的照片数组
    var images: [UIImage] = []
    //滤镜效果图
    var filterImages: [UIImage] = []
    //比例大小
    var proportion: XProportion = .oneToOne
    //当前编辑模式，操作用
    var editMode:XEditImageMode = .fullImageEditing
    
    init(images: [UIImage]) {
        self.images = images
    }
    init (){}

}
