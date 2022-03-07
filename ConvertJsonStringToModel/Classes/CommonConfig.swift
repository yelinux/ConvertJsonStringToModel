//
//  CommonConfig.swift
//  ConvertJsonStringToModel
//
//  Created by chenyehong on 2022/2/23.
//

import Foundation

let replacedDic = ["id":"ID"]
func replacedPropertyName(_ key : String) -> String {
    if let name = replacedDic[key] {
        return name
    }
    return key
}
