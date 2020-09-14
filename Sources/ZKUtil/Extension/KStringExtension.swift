//
//  KStringExtension.swift
//  MicroVote
//
//  Created by gongrong on 2018/6/25.
//  Copyright © 2018年 张坤. All rights reserved.
//

import UIKit
import CommonCrypto
extension String {
    
    /// 字符串md5
    public var md5:String{
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize(count: digestLen)
        
        return String(format: hash as String)
    }
    
    /// 字符串是否是ip地址
    public var isIP:Bool{
        
        let ipArray = self.components(separatedBy: ".")
        if ipArray.count == 4 {
            for ipnumberStr in ipArray {
                let ipnumber =  Int(ipnumberStr) ?? 0
                if !(ipnumber >= 0 && ipnumber <= 255) {
                    return false
                }
            }
            return true
        }
        return false
    }
    
    /// 本地化语言
    public var localized:String{
        return NSLocalizedString(self, comment: self)
    }
    
    public func size(font: UIFont, size: CGSize) -> CGSize {
        let attribute = [ NSAttributedString.Key.font: font ]
        let conten = NSString(string: self)
        return conten.boundingRect(with: CGSize(width: size.width, height: size.height), options: .usesLineFragmentOrigin, attributes: attribute, context: nil).size
    }
}
