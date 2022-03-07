//
//  FileCreatorUtil.swift
//  ConvertJsonStringToModel
//
//  Created by chenyehong on 2022/2/21.
//

import Cocoa

class FileCreatorUtil: NSObject {
    
    let manager = FileManager.default
    
    func clearFile() -> String?{
        let exist = manager.fileExists(atPath: fileDir.path)
        if exist {
            do {
                try manager.removeItem(atPath: fileDir.path)
                print("已存在，删除成功")
            } catch {
                print("已存在，删除失败")
                return "没有文件操作权限，请到系统设置开通，并重新启动程序"
            }
        }
        do {
            try manager.createDirectory(at: fileDir, withIntermediateDirectories: true, attributes: nil)
            print("创建文件夹成功")
        } catch {
            print("创建文件夹失败")
            return "没有文件操作权限，请到系统设置开通，并重新启动程序"
        }
        return nil
    }
    
    func createOcFile(_ model : FileClassModel, _ callback : ((_ msg : String) -> Void)){
        let header = ObjcTemplateUtil.headerTextByModel(model)
        createFile("\(model.fileName!).h", header, callback)
        let implement = ObjcTemplateUtil.implementByModel(model)
        createFile("\(model.fileName!).m", implement, callback)
    }
    
    func createSwFile(_ model : FileClassModel, _ callback : ((_ msg : String) -> Void)){
        let content = SwiftTemplateUtil.classTextByModel(model)
        createFile("\(model.fileName!).swift", content, callback)
    }
    
    func createFile(_ fileName : String, _ content : String, _ callback : ((_ msg : String) -> Void)){
        let file = fileDir.appendingPathComponent(fileName)
        let exist = manager.fileExists(atPath: file.path)
        if !exist {
            let createSuccess = manager.createFile(atPath: file.path,contents:content.data(using: String.Encoding.utf8),attributes:nil)
            if createSuccess {
                callback("导出\(file)")
            } else {
                callback("导出\(file)失败")
            }
        }
    }
    
    lazy var fileDir : URL = {
        let manager = FileManager.default
        let urlForDocument = manager.urls( for: .downloadsDirectory,
                                                   in:.userDomainMask)
        let url = urlForDocument[0].appendingPathComponent("__ModelResult", isDirectory: true)
        return url
    }()
}
