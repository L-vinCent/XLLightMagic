//
//  XTemplateModel.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/25.
//

import HandyJSON

struct XTemplateModel: HandyJSON {
    var name: String??
    var version: String?
    var imageCount: Int?
    var ratioW: Int?
    var ratioH: Int?
    var thumbnail: String?
    var layer: Layer?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.imageCount <-- "image_count"
        mapper <<< self.ratioH <-- "ratio_h"
        mapper <<< self.ratioW <-- "ratio_w"
        }
    
    
}

struct Layer: HandyJSON {
    var type: Int?
    var rect: Rect?
    var layerList: [LayerItem]?
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.layerList <-- "layer_list"
        }
}

struct Rect: HandyJSON {
    //返回的是比例值
    var left: Double?
    var top: Double?
    var width: Double?
    var height: Double?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.left <-- "l"
        mapper <<< self.top <-- "t"
        mapper <<< self.width <-- "w"
        mapper <<< self.height <-- "h"
        }

}

struct LayerItem: HandyJSON {
    var type: Int?
    var rect: Rect?
}
