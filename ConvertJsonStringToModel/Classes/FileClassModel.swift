//
//  FileModel.swift
//  ConvertJsonStringToModel
//
//  Created by chenyehong on 2022/2/21.
//

import Cocoa

class FileClassModel: NSObject {

    var fileName : String?
    
    var propertys : [FileProperty] = []
}

class FileProperty : NSObject {
    var propertyName : String?
    var propertyType : PropertyType?
}

enum PropertyType{
    case id
    case int
    case string
    case float
    case bool
    case model(String)
    case list(ArrayItemType)
}

enum ArrayItemType{
    case id
    case int
    case string
    case float
    case bool
    case model(String)
}
