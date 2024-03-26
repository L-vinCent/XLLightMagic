//
//  XEditTool.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/25.
//

import HandyJSON
import UIKit
//编辑的工具类
class XTemplateTools{
    
    //todo:根据相册图片个数，返回当前支持的模板布局
    //模板Json->模型
    class func loadJSONAsTemplate(jsonName: String) -> XTemplateModel? {
         guard let jsonURL = Bundle.main.url(forResource: jsonName, withExtension: "json") else {
             print("JSON file '\(jsonName)' not found.")
             return nil
         }

         do {
             let jsonData = try Data(contentsOf: jsonURL)
             if let jsonString = String(data: jsonData, encoding: .utf8) {
                 if let template = JSONDeserializer<XTemplateModel>.deserializeFrom(json: jsonString) {
                     print("Template loaded successfully.")
                     return template
                 } else {
                     print("Failed to deserialize JSON into Template object.")
                     return nil
                 }
             } else {
                 print("Failed to convert JSON data to string.")
                 return nil
             }
         } catch {
             print("Error reading JSON file '\(jsonName)':", error)
             return nil
         }
     }
    
}
