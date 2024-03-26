//
//  XModel.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/20.
//

import HandyJSON

struct ImageModel: HandyJSON {
    var image_id: Int = 0
    var img05: String?
}

struct ChapterModel: HandyJSON {
    var status: Int = 0
    var image_list: [ImageModel]?
    var userId: String?
    var title: String?
}

extension Array: HandyJSON{}

struct ReturnData<T: HandyJSON>: HandyJSON {
    var message:String?
    var returnData: T?
    var stateCode: Int = 0
}

struct ResponseData<T: HandyJSON>: HandyJSON {
    var code: Int = 0
    var data: ReturnData<T>?
}
