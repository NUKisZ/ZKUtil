//
//  Config.swift
//  GZ
//
//  Created by 张坤 on 2017/9/30.
//  Copyright © 2017年 张坤. All rights reserved.
//

import UIKit
#if canImport(DeviceKit)
import DeviceKit
//获取设备的型号 例如：iPhone
public let kDeviceModel = Device.init().description // UIDevice.current.model
#endif
public let kUserDefaults = UserDefaults.standard

//屏幕宽度
public let kScreenWidth = UIScreen.main.bounds.size.width
//屏幕高度
public let kScreenHeight = UIScreen.main.bounds.size.height
public let kScale = kScreenWidth/375
//状态栏高度
public let kScreenStateHeight = UIApplication.shared.statusBarFrame.size.height
//导航栏高度
public let kScreenNavBarHeight = UINavigationController().navigationBar.frame.size.height
//tabbar的高度
public let kScreenTabbarHeight = UITabBarController().tabBar.bounds.size.height

public let kScreenTabbarBottomHeight = (83-kScreenTabbarHeight > 0) ? 83-kScreenTabbarHeight :0
//获取设备名称 例如：**的手机
public let kDeviceName = UIDevice.current.name
//获取系统名称 例如：iPhone OS
public let kSysName = UIDevice.current.systemName
//获取系统版本 例如：9.2
public let kSysVersion = UIDevice.current.systemVersion
//获取设备唯一标识符 例如：FBF2306E-A0D8-4F4B-BDED-9333B627D3E6
public let kDeviceUUID = (UIDevice.current.identifierForVendor?.uuidString)!


public let kInfoDic = Bundle.main.infoDictionary! as [String:Any]
public let kAppVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"]) as! String // 获取App的版本
public let kAppBuildVersion = (Bundle.main.infoDictionary?["CFBundleVersion"]) as! String      // 获取App的build版本
public let kAppName = (Bundle.main.infoDictionary?["CFBundleDisplayName"])! as! String          // 获取App的名称
//public let kUserPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last?.appendingPathComponent("currentUser.arch"))!
//public let kServerPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last?.appendingPathComponent("currentServer.arch"))!

public func kScaleWidth(width:CGFloat)->CGFloat{return kScreenWidth/375*width}

@available(iOS 11.0, *)
public let kInsets = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero

//var context = JSContext()
//context = web?.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext?
public let javaScriptContext = "documentView.webView.mainFrame.javaScriptContext"
