//
//  SwiftTemplateUtil.swift
//  ConvertJsonStringToModel
//
//  Created by chenyehong on 2022/2/23.
//

import Cocoa

class SwiftTemplateUtil: NSObject {

    static func classTextByModel(_ model : FileClassModel) -> String {
        var content = ""
        for pt in model.propertys {
            let propertyName = replacedPropertyName(pt.propertyName!)
            switch pt.propertyType {
            case .id:
                content += "    var \(propertyName) : Any?\n"
            case .int:
                content += "    var \(propertyName) : Int?\n"
            case .string:
                content += "    var \(propertyName) : String?\n"
            case .float:
                content += "    var \(propertyName) : Float?\n"
            case .bool:
                content += "    var \(propertyName) : Bool?\n"
            case .model(let pName):
                content += "    var \(propertyName) : \(pName)?\n"
                break
            case .list(let itemType):
                switch itemType {
                    case .int:
                        content += "    var \(propertyName) : [Int]?\n"
                    case .string:
                        content += "    var \(propertyName) : [String]?\n"
                    case .float:
                        content += "    var \(propertyName) : [Float]?\n"
                    case .bool:
                        content += "    var \(propertyName) : [Bool]?\n"
                    case .model(let pName):
                        content += "    var \(propertyName) : [\(pName)]?\n"
                    default:
                        content += "    var \(propertyName) : [Any]?\n"
                }
                break
            default:
                break
            }
        }
        
        var includeTxt = getIncludeTxt(model.fileName!)
        includeTxt += "import UIKit\n"
        includeTxt += "\nclass \(model.fileName!): NSObject, HandyJSON {\n\n"
        content = includeTxt + content + "\n"
        content = content + "    required override init() {\n        super.init()\n    }\n\n"
        
        var replaceCode = ""
        for pt in model.propertys {
            let propertyName = replacedPropertyName(pt.propertyName!)
            if propertyName != pt.propertyName! {
                replaceCode += "        mapper.specify(property: &\(propertyName), name: \"\(pt.propertyName!)\")\n"
            }
        }
        if replaceCode.count > 0 {
            replaceCode =
            "    func mapping(mapper: HelpingMapper) {\n" +
            replaceCode +
            "    }\n\n"
            content += replaceCode
        }
        
        content = content + "}"
        
        return content
    }
    
    static func getIncludeTxt(_ fileName : String) -> String {
        return "//\n" +
        "// \(fileName).swift\n" +
        "// ConvertJsonStringToModel\n" +
        "//\n" +
        "// Created by mac on 2022/xx/xx.\n" +
        "//\n\n"
    }
}
