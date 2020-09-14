//
//  KUIImageExtension.swift
//  MicroVote
//
//  Created by gongrong on 2018/4/18.
//  Copyright © 2018年 张坤. All rights reserved.
//

import Foundation
extension UIImage{
    public func getPixelColor(pos:CGPoint) -> UIColor{
//        let pixelData=CGDataProviderCopyData(CGImageGetDataProvider(self.cgImage!)!)
        let pixelData=CGDataProvider(data: cgImage?.dataProvider as! CFData)
        let data:UnsafePointer<UInt8> = CFDataGetBytePtr((pixelData as! CFData))
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    public func rotation( rotation orientation: UIImage.Orientation) -> UIImage? {
        let image = self
        var rotate: Float = 0.0
        var rect: CGRect
        var translateX: Float = 0
        var translateY: Float = 0
        var scaleX: Float = 1.0
        var scaleY: Float = 1.0
        switch orientation {
        case .left:
            rotate = Float.pi/2
            rect = CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width)
            translateX = 0
            translateY = Float(-rect.size.width)
            scaleY = Float(rect.size.width / rect.size.height)
            scaleX = Float(rect.size.height / rect.size.width)
        case .right:
            rotate = 33 * Float.pi/2
            rect = CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width )
            translateX = Float(-rect.size.height)
            translateY = 0
            scaleY = Float(rect.size.width / rect.size.height)
            scaleX = Float(rect.size.height / rect.size.width)
        case .down:
            rotate = .pi
            rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            translateX = Float(-rect.size.width)
            translateY = Float(-rect.size.height)
        default:
            rotate = 0.0
            rect = CGRect(x: 0, y: 0, width: image.size.width , height: image.size.height)
            translateX = 0
            translateY = 0
        }
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        //做CTM变换
        context?.translateBy(x: 0.0, y: rect.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.rotate(by: CGFloat(rotate))
        context?.translateBy(x: CGFloat(translateX), y: CGFloat(translateY))
        context?.scaleBy(x: CGFloat(scaleX), y: CGFloat(scaleY))
        //绘制图片
        context?.draw((image.cgImage)!, in: CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height))
        let newPic: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        return newPic
    }
    public func drawTextInImage(text:String)->UIImage {
        //开启图片上下文
        UIGraphicsBeginImageContext(self.size)
        //图形重绘
//        self.draw(in: CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height))
//        //水印文字属性
//        let att = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 10),NSAttributedStringKey.backgroundColor:UIColor.white,NSAttributedStringKey.foregroundColor:UIColor.black]
//        //水印文字大小
//        let text = NSString(string: text)
//        let size =  text.size(withAttributes: att)
//        //绘制文字
//        text.draw(in: CGRect.init(x: self.size.width/2, y: self.size.height/2, width: size.width, height: size.height), withAttributes: att)
//        //从当前上下文获取图片
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        label.text = text
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 120)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.drawText(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        
        return image!
        
    }
    public func drawTextInImage(text:NSMutableAttributedString)->UIImage {
        //开启图片上下文
        UIGraphicsBeginImageContext(self.size)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 120)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.attributedText = text
        label.drawText(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        
        return image!
        
    }
}
