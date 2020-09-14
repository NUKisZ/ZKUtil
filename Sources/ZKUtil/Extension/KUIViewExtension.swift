//
//  KUIViewExtension.swift
//  MicroVote
//
//  Created by gongrong on 2018/4/18.
//  Copyright © 2018年 张坤. All rights reserved.
//

import UIKit
extension UIView{
    
    public func colorOfPoint(point:CGPoint) -> UIColor {
        
        var pixel: [CUnsignedChar] = [0, 0, 0, 0]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        
        layer.render(in: context!)
        
        let red: CGFloat   = CGFloat(pixel[0]) / 255.0
        let green: CGFloat = CGFloat(pixel[1]) / 255.0
        let blue: CGFloat  = CGFloat(pixel[2]) / 255.0
        let alpha: CGFloat = CGFloat(pixel[3]) / 255.0
        
        let color = UIColor(red:red, green: green, blue:blue, alpha:alpha)
        
        return color
    }
    public func colorOfPoint(point:CGPoint) -> CGFloat {
        
        var pixel: [CUnsignedChar] = [0, 0, 0, 0]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        
        layer.render(in: context!)
        
        let red: CGFloat   = CGFloat(pixel[0]) / 255.0
        let green: CGFloat = CGFloat(pixel[1]) / 255.0
        let blue: CGFloat  = CGFloat(pixel[2]) / 255.0
        let alpha: CGFloat = CGFloat(pixel[3]) / 255.0
        
        return red + green + blue + alpha
    }
    
    /// UIView，便捷获取 frame.size.width 值
    public var width: CGFloat {
        return self.frame.size.width
    }
    /// UIView，便捷获取 frame.size.height 值
    public var height: CGFloat {
        return self.frame.size.height
    }
    /// UIView，便捷获取 frame.origin.x 值
    public var x: CGFloat {
        return self.frame.origin.x
    }
    /// UIView，便捷获取 frame.origin.y 值
    public var y: CGFloat {
        return self.frame.origin.y
    }
}
