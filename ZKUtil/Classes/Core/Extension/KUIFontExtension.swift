//
//  KUIFontExtension.swift
//  GZ
//
//  Created by gongrong on 2017/11/23.
//  Copyright © 2017年 张坤. All rights reserved.
//

import Foundation

private struct FontCustomType{
    static let PingFangSCMedium    = "PingFangSC-Medium"
    static let PingFangSCSemibold  = "PingFangSC-Semibold"
    static let PingFangSCRegular   = "PingFangSC-Regular"
    static let SFUITextMedium      = ".SFUIText-Medium"
    static let SFUITextRegular     = ".SFUIText-Regular"
    static let HiraginoSansW3      = "HiraginoSans-W3"
    static let HiraginoSansW6      = "HiraginoSans-W6"
    static let MicrosoftYaHei      = "MicrosoftYaHei"
    static let HiraginoSansGBW3    = "HiraginoSansGB-W3"
    static let SourceHanSansCNRegular = "SourceHanSansCN-Regular"
    static let RobotoLight         = "Roboto-Light"
}
extension UIFont{
    //系统字体库
    public class func PingFangSCRegular(size:CGFloat) -> UIFont{
        return UIFont(name: FontCustomType.PingFangSCRegular, size: size)!
    }
    public class func PingFangSCSemibold(size:CGFloat) -> UIFont{
        return UIFont(name: FontCustomType.PingFangSCSemibold, size: size)!
    }
    public class func PingFangSCMedium(size:CGFloat) -> UIFont{
        return UIFont(name: FontCustomType.PingFangSCMedium, size: size)!
    }
    
    public class func HiraginoSansW3(size:CGFloat) -> UIFont{
        return UIFont(name: FontCustomType.HiraginoSansW3, size: size)!
    }
    public class func HiraginoSansW6(size:CGFloat) -> UIFont{
        return UIFont(name: FontCustomType.HiraginoSansW6, size: size)!
    }
    public class func SFUITextMedium(size:CGFloat) -> UIFont{
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: size, weight: .medium)
        } else {
            return systemFont(ofSize: size)
        }
    }
    public class func SFUITextRegular(size:CGFloat) -> UIFont{
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: size, weight: .regular)
        } else {
            return systemFont(ofSize:size)
        }
    }
    //自定义添加字体库文件
    //需要先将.ttf 或.otf 文件加入项目中,在info.plist 中添加字体后才可以使用
    public class func MicrosoftYaHei(size:CGFloat) -> UIFont{
        if let font = UIFont(name: FontCustomType.MicrosoftYaHei, size: size){
            return font
        } else {
            print("警告:没有发现MicrosoftYaHei字体库")
            return UIFont.PingFangSCRegular(size:size)
        }
    }
    public class func HiraginoSansGBW3(size:CGFloat) -> UIFont{
        if let font = UIFont(name: FontCustomType.HiraginoSansGBW3, size: size){
            return font
        } else {
            print("警告:没有发现HiraginoSansGB-W3字体库")
            return UIFont.PingFangSCRegular(size:size)
        }
    }
    public class func SourceHanSansCNRegular(size:CGFloat) -> UIFont{
        if let font = UIFont(name: FontCustomType.SourceHanSansCNRegular, size: size){
            return font
        } else {
            print("警告:没有发现SourceHanSansCN-Regular字体库")
            return UIFont.PingFangSCRegular(size:size)
        }
    }
    public class func RobotoLight(size:CGFloat) -> UIFont{
        if let font = UIFont(name: FontCustomType.RobotoLight, size: size){
            return font
        } else {
            print("警告:没有发现SourceHanSansCN-Regular字体库")
            return UIFont.PingFangSCRegular(size:size)
        }
    }
    
}
