//
//  KDateExtension.swift
//  MicroVote
//
//  Created by gongrong on 2018/6/25.
//  Copyright © 2018年 张坤. All rights reserved.
//

import UIKit

extension Date{
    public var today:String{
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy_MM_dd"
        return "\(dformatter.string(from: self))"
    }
    public var nowString:String{
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        return "\(dformatter.string(from: self))"
    }
    public var nowTimeInterval:Int{
        let timeInterval:TimeInterval = self.timeIntervalSince1970
        return Int(timeInterval)
    }
    
}
