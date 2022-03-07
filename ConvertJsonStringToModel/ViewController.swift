//
//  ViewController.swift
//  ConvertJsonStringToModel
//
//  Created by chenyehong on 2022/2/21.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBOutlet weak var myScrollView: NSScrollView!
    let fileUtil = FileCreatorUtil.init()
    @IBOutlet var msgTextView: NSTextView!

    @IBOutlet var tfPrefix: NSTextField!
    @IBOutlet var tfClassName: NSTextField!
    
    @IBOutlet weak var menuItemMJ: NSMenuItem!
    @IBOutlet weak var menuItemHandJson: NSMenuItem!
    
    @IBAction func clickStart(_ sender: Any) {
        
        msgTextView.textStorage?.setAttributedString(NSAttributedString.init(string: ""))
        
        let classname = tfClassName.stringValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        guard classname.count > 0 else {
            appendMessage("请输入类名")
            return
        }
        
        if let error = fileUtil.clearFile() {
            appendMessage(error)
            return
        }
        let myTextView: NSTextView = myScrollView.documentView! as! NSTextView
        let myText:String = myTextView.string
        appendMessage("开始解析json字符串")
        let data = myText.data(using: String.Encoding.utf8)
        if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
            
            fileMap = [:]
            _ = handleDic(classname, dict as NSDictionary)
            
            let blockFunc = {(_ msg : String) in
                self.appendMessage(msg)
            }
            
            for (_, value) in fileMap {
                if menuItemMJ.state == .on {
                    fileUtil.createOcFile(value, blockFunc)
                } else {
                    fileUtil.createSwFile(value, blockFunc)
                }
            }
            
            appendMessage("转换完成!")
            shell(command: "open \(fileUtil.fileDir.path)")
        } else {
            appendMessage("解析失败，请输入正确的json字符串!")
        }
    }
    
    func appendMessage(_ message : String){
        let scroll = (NSMaxY(msgTextView.visibleRect) == NSMaxY(msgTextView.bounds))
        msgTextView.textStorage?.append(NSAttributedString.init(string: "\(message)\n", attributes: [NSAttributedString.Key.foregroundColor : NSColor.white]))
        if scroll {
            msgTextView.scrollRangeToVisible(NSRange.init(location: msgTextView.string.count, length: 0))
        }
    }
    
    var fileMap : [String : FileClassModel] = [:]
    func handleDic(_ name : String, _ dic : NSDictionary) -> String {
        
        let prefix = tfPrefix.stringValue
        
        var fileName = "\(prefix)\(name.capitalized)"
        var count = 0
        while fileMap.contains(where: { (key: String, value: FileClassModel) in
            return key == fileName
        }) {
            count += 1
            fileName = "\(prefix)\(count)\(name.capitalized)"
        }
        let fileModel = FileClassModel.init()
        fileModel.fileName = fileName
        fileMap[fileModel.fileName!] = fileModel
        
        for (key, value) in dic {
            let pt = FileProperty.init()
            pt.propertyName = (key as! String)
            pt.propertyType = calPropertyType(pt.propertyName!, value)
            fileModel.propertys.append(pt)
        }
        
        return fileName
    }
    
    func calPropertyType(_ name : String, _ value : Any) -> PropertyType{
        if let value = value as? NSDictionary {
            let pName = handleDic(name, value)
            return PropertyType.model(pName)
        }
        if let array = value as? NSArray {
            if array.count > 0 {
                let obj = array[0]
                if let obj = obj as? NSDictionary {
                    let pName = handleDic(name, obj)
                    return PropertyType.list(ArrayItemType.model(pName))
                }
                if obj is String {
                    return PropertyType.list(.string)
                }
                if OcTool.isPureFloat(value) {
                    return PropertyType.list(.float)
                }
                if OcTool.isPureBool(value) {
                    return PropertyType.list(.bool)
                }
                if OcTool.isPureInt(value) {
                    return PropertyType.list(.int)
                }
            }
            return PropertyType.list(.id)
        }
        if value is String {
            return .string
        }
        if OcTool.isPureFloat(value) {
            return .float
        }
        if OcTool.isPureBool(value) {
            return .bool
        }
        if OcTool.isPureInt(value) {
            return .int
        }
        
        return .id
    }
    
    @discardableResult
    func shell(command: String) -> String {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", command]

        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String

        return output
    }
}

