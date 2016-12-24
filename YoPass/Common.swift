//
//  Common.swift
//  YoPass
//
//  Created by yztgx on 16/12/15.
//  Copyright © 2016年 yztgx. All rights reserved.
//

import Foundation



extension String{
    
    var md5: String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        var cryptData    = [UInt8](repeating:0, count:digestLen)
        CC_MD5(str!, strLen, &cryptData)
        
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", cryptData[i])
        }
        
        
        return String(format: hash as String)
    }
    
    var md5_16: String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        
        var cryptData    = [UInt8](repeating:0, count:digestLen)
        CC_MD5(str!, strLen, &cryptData)
        
        let hash = NSMutableString()
        for i in 4..<digestLen-4 {
            hash.appendFormat("%02x", cryptData[i])
        }
        return String(format: hash as String)
    }
    
    //    func stringFromBytes(bytes: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String{
    //        let hash = NSMutableString()
    //        for i in 0..<length {
    //            hash.appendFormat("%02x", bytes[i])
    //        }
    //        bytes.deallocate(capacity: length)
    //        return String(format: hash as String)
    //    }
    //
    //
    //
    //    var sha256String: String! {
    //        let str = self.cString(using: String.Encoding.utf8)
    //        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
    //        let digestLen = Int(CC_SHA256_DIGEST_LENGTH)
    //        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
    //        CC_SHA256(str!, strLen, result)
    //        return stringFromBytes(bytes: result, length: digestLen)
    //    }
    
    
}

class CommonSetting
{
    static var m_passMD5 = ""
    static var m_passMD5_16 = ""
    static let m_filePass = "storage.dat"
    static let m_workPath = NSHomeDirectory() + "/Library/TestPass"
    static let m_softVer = 1.1
    static var m_dbVer = 0.1
}
class CommonFunc
{
    //计算规则：1-5分，1极不安全，5最安全
    //默认1分、包含数字+1分，包含字母+1分，长度超过6 +1,包含特殊符号+1
    //每个字符之间相减值相同者减1分
    
    static func CheckPassSafe(password: String)->Int
    {
        var numpassList = [UInt32]()
        var numReduceList = [Int]()
        var numCount = 0
        var numNum = 0
        var numCharUpper = 0
        var numCharLoser = 0
        var numSpecial = 0
        var numReduceCompare = -1
        for ch in password.unicodeScalars
        {
            numpassList.append(UnicodeScalar(ch).value)
            
        }
        
        if numpassList.count >= 6
        {
            numCount = 1
        }
        else
        {
            return 1
        }
        
        var oldnum: UInt32 = 0
        var reduce: Int = 0
        for num in numpassList
        {
            if (num >=  UnicodeScalar("0")!.value && num <=  UnicodeScalar("9")!.value)
            {
                numNum =  1
            }else if (num >=  UnicodeScalar("a")!.value && num <=  UnicodeScalar("z")!.value)
            {
                numCharLoser = 1
                
            }else if (num >=  UnicodeScalar("A")!.value && num <=  UnicodeScalar("Z")!.value)
            {
                numCharUpper = 1
            }
            else{
                numSpecial = 1
            }
            if oldnum != 0
            {
                reduce = Int(num) - Int(oldnum)
                numReduceList.append(reduce)
            }
            oldnum = num
        }
        
        if numReduceList.count > 2
        {
            let numReduceTmp = numReduceList[0]
            for numReduceIndex in numReduceList
            {
                if numReduceTmp != numReduceIndex
                {
                    numReduceCompare = 0
                    break
                }
            }
        }
        
        
        return numCount+numNum+numCharUpper+numCharLoser+numSpecial+numReduceCompare
    }

}
class Crypto
{
    static func EnCryptoAES256(str: String,key: String,iv: String) -> String?
    {
        let keyString  = key.md5
        let ivString = iv.md5_16
        let keyData    = keyString?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) as NSData!
        print("keyLength   = \(keyData?.length), keyData   = \(keyData)")
        let data = str.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) as NSData!
        print("data length = \(data?.length), data      = \(data)")
        
        if (keyData == nil || data == nil)
        {
            return nil
        }
        
        let cryptLength  = size_t((data?.length)!+kCCBlockSizeAES128)
        var cryptData    = [UInt8](repeating:0, count:cryptLength)
        
        let keyLength              = size_t(kCCKeySizeAES256)
        let operation: CCOperation = UInt32(kCCEncrypt)
        let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
        let options:   CCOptions   = UInt32(kCCOptionPKCS7Padding)
        
        //Options = noPadding时，CCCrypt出现kCCAlignmentError，添加Padding一切正常
        //目前无法解释问题所在，只能先加上Padding
        
        
        var numBytesEncrypted :size_t = 0
        
        let cryptStatus = CCCrypt(operation,
                                  algoritm,
                                  options,
                                  keyData!.bytes, keyLength,
                                  ivString,
                                  data!.bytes, data!.length,
                                  &cryptData, cryptLength,
                                  &numBytesEncrypted)
        
        if Int(cryptStatus) == kCCSuccess {
            
            let dataCrypt = NSData(bytes:cryptData, length:numBytesEncrypted)
            print("cryptLength = \(numBytesEncrypted), cryptData = \(dataCrypt)")
            let base64cryptString = dataCrypt.base64EncodedString(options: .lineLength64Characters)//
            
            print("base64cryptString = \(base64cryptString)")
            return base64cryptString
            
        } else {
            print("Error: \(cryptStatus)")
            return nil
        }
        
    }
   
    

    
    
    static func DeCryptoAES256(str: String,key: String,iv: String) -> Data?
    {
        
        let keyString  = key.md5
        let ivString = iv.md5_16
        let keyData    = keyString?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) as NSData!
        let data = NSData(base64Encoded: str, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        var dataRet: Data? = nil
        print("keyLength   = \(keyData?.length), keyData   = \(keyData)")
        print("data length = \(data?.length), data      = \(data)")
        
        if (keyData == nil || data == nil)
        {
            return dataRet
        }
        
        let cryptLength  = size_t((data?.length)!+kCCBlockSizeAES128)
        var cryptData    = [UInt8](repeating:0, count:cryptLength)
        
        
        let keyLength              = size_t(kCCKeySizeAES256)
        let operation: CCOperation = UInt32(kCCDecrypt)
        let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
        let options:   CCOptions   = UInt32(kCCOptionPKCS7Padding)
        
        var numBytesEncrypted :size_t = 0
        
        let cryptStatus = CCCrypt(operation,
                                  algoritm,
                                  options,
                                  keyData!.bytes, keyLength,
                                  ivString,
                                  data!.bytes, data!.length,
                                  &cryptData, cryptLength,
                                  &numBytesEncrypted)
        
        if Int(cryptStatus) == kCCSuccess
        {
            cryptData.removeSubrange(numBytesEncrypted..<cryptData.count)
    
         //   let strDecode = String(bytes:cryptData,encoding:String.Encoding.utf8)
          //  print("decryptString = \(strDecode)")
          //  return strDecode
            dataRet = Data(bytes:cryptData)
            
        } else {
            print("Error: \(cryptStatus)")

        }
        return dataRet
        
    }
}
