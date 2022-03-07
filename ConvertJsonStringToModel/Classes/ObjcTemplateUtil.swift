//
//  ObjcTemplateUtil.swift
//  ConvertJsonStringToModel
//
//  Created by chenyehong on 2022/2/21.
//

import Cocoa

class ObjcTemplateUtil: NSObject {
    
    static func headerTextByModel(_ model : FileClassModel) -> String{
        var includeList : [String] = []
        var content = ""
        for pt in model.propertys {
            let propertyName = replacedPropertyName(pt.propertyName!)
            switch pt.propertyType {
            case .id:
                content += "@property (strong, nonatomic) id \(propertyName);\n"
            case .int:
                content += "@property (assign, nonatomic) NSInteger \(propertyName);\n"
            case .string:
                content += "@property (copy, nonatomic) NSString *\(propertyName);\n"
            case .float:
                content += "@property (assign, nonatomic) double \(propertyName);\n"
            case .bool:
                content += "@property (assign, nonatomic) BOOL \(propertyName);\n"
            case .model(let pName):
                content += "@property (strong, nonatomic) \(pName) *\(propertyName);\n"
                if !includeList.contains(pName){
                    includeList.append(pName)
                }
                break
            case .list(let itemType):
                switch itemType {
                    case .string:
                        content += "@property (copy, nonatomic) NSArray <NSString*> *\(propertyName);\n"
                    case .model(let pName):
                        content += "@property (copy, nonatomic) NSArray <\(pName)*> *\(propertyName);\n"
                        if !includeList.contains(pName){
                            includeList.append(pName)
                        }
                    default:
                        content += "@property (copy, nonatomic) NSArray *\(propertyName);\n"
                }
                break
            default:
                break
            }
        }
        
        var includeTxt = getIncludeTxt(model.fileName!)
        includeTxt += "#import <Foundation/Foundation.h>\n"
        for item in includeList {
            includeTxt += "#import \"\(item).h\"\n"
        }
        includeTxt += "\n@interface \(model.fileName!) : NSObject\n\n"
        content = includeTxt + content
        content = content + "\n@end"
        
        return content
    }
    
    static func implementByModel(_ model : FileClassModel) -> String{
        var content = getIncludeTxt(model.fileName!)
        content += "#import \"\(model.fileName!).h\"\n\n"
        content += "@implementation \(model.fileName!)\n\n"
        
        var replaceCode = ""
        for pt in model.propertys {
            let propertyName = replacedPropertyName(pt.propertyName!)
            if propertyName != pt.propertyName! {
                replaceCode += "        @\"\(propertyName)\" : @\"\(pt.propertyName!)\",\n"
            }
        }
        if replaceCode.count > 0 {
            replaceCode =
            "+ (NSDictionary *)mj_replacedKeyFromPropertyName {\n" +
            "    return @{\n" +
            replaceCode +
            "    };\n" +
            "}\n\n"
            content += replaceCode
        }
        
        var classInArrayCode = ""
        for pt in model.propertys {
            switch pt.propertyType {
            case .list(let itemType):
                switch itemType {
                case .model(let pName):
                    classInArrayCode += "        @\"\(pt.propertyName!)\" : NSStringFromClass(\(pName).class),\n"
                    break
                default:
                    break
                }
            default:
                break
            }
        }
        
        if classInArrayCode.count > 0 {
            classInArrayCode =
            "+ (NSDictionary *)mj_objectClassInArray {\n" +
            "    return @{\n" +
            classInArrayCode +
            "    };\n" +
            "}\n\n"
            content += classInArrayCode
        }
        
        content += "@end"
        return content
    }

    static func getIncludeTxt(_ fileName : String) -> String {
        return "//\n" +
        "// \(fileName).h\n" +
        "// ConvertJsonStringToModel\n" +
        "//\n" +
        "// Created by mac on 2022/xx/xx.\n" +
        "// Copyright © 2022 mac. All rights reserved.\n" +
        "//\n\n"
    }
}
