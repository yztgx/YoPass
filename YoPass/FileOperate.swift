//
//  FileOperate.swift
//  TestFile
//
//  Created by yztgx on 16/11/22.
//  Copyright © 2016年 yztgx. All rights reserved.
//

import Foundation

class FileOperate{
    var m_fileName = ""
    let m_localPath = NSHomeDirectory() + "/Library/YoPass/"
    init(fileName: String,isLocal:Bool = true)
    {
        if isLocal == true {
           // self.m_fileName = Bundle.main.bundlePath + "/" + fileName
            
            self.m_fileName = m_localPath + fileName
            
        }
        else
        {
            self.m_fileName = fileName
        }
    }
    
    func isFileExist()->Bool
    {
        let manager = FileManager.default
        return manager.fileExists(atPath: m_fileName)
    }
    
    func CreateNewFile()
    {
        let manager = FileManager.default
        try? manager.createDirectory(atPath: m_localPath, withIntermediateDirectories: false, attributes: nil)
        let data = manager.contents(atPath: Bundle.main.path(forResource: "source.xml", ofType: nil)!)
        if (data != nil)
        {
            let strData = String(bytes: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            if (strData != nil)
            {
                WriteFile(strdata: strData!)
            }
            
        }
    }
    
    func ReadFile()->Data?
    {

        let manager = FileManager.default
        let data = manager.contents(atPath: m_fileName)
        if data == nil{
          return nil
        }
        let dataDecode = Decode(data: data!)
        return dataDecode
    }
    func ReadFiletoString()->NSString?
    {
        var strData: NSString? = nil
        let dataRead = ReadFile()
        if (dataRead != nil)
        {
            strData = NSString(data: dataRead!, encoding: String.Encoding.utf8.rawValue)
        }
        return strData
    }
    
    func WriteFile(strdata: String)
    {
        let data = Encode(str: strdata)
        let url = NSURL(fileURLWithPath: m_fileName)
        BakFile()
        try?  data?.write(to: url as URL)
        
    }
    
    func BakFile()
    {
        let toFile = m_fileName + ".bak"
        let fromURL = NSURL(fileURLWithPath: m_fileName)
        let toURL = NSURL(fileURLWithPath: toFile)
        let manager = FileManager.default
        try? manager.moveItem(at: fromURL as URL, to: toURL as URL)

    }

    
    func DeleteFile()
    {
        let manager = FileManager.default
        try? manager.removeItem(atPath: m_fileName)

    }

    
    func CheckFileValid()->Bool
    {
        let str = ReadFiletoString()
        if (str != nil)
        {
            return str!.contains("<?xml version=")//\"1.0\" encoding=\"UTF-8\"?>")
        }
        else
        {
            return false
        }
    }
    
    
    func Decode(data: Data)->Data?
    {
        let strdata = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        let dataDecodeAES = Crypto.DeCryptoAES256(str: strdata as! String, key: CommonSetting.m_passMD5, iv: CommonSetting.m_passMD5_16)
        return dataDecodeAES

    }
    func Encode(str: String)->Data?
    {
        
        let strAES = Crypto.EnCryptoAES256(str: str, key: CommonSetting.m_passMD5, iv: CommonSetting.m_passMD5_16)
        if strAES != nil
        {
            let data = strAES?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            return data
        }
        else
        {
            return nil
        }
    }

}
