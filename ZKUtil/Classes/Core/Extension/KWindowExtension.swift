//
//  KWindowExtension.swift
//  GZ
//
//  Created by gongrong on 2017/11/28.
//  Copyright © 2017年 张坤. All rights reserved.
//

import Foundation
extension UIWindow{
    public class func currentViewController() -> UIViewController{
        let window = UIApplication.shared.delegate?.window!
        var topViewController = (window?.rootViewController)!
        while (true) {
            if ((topViewController.presentedViewController) != nil) {
                topViewController = topViewController.presentedViewController!
            } else if (topViewController.isKind(of: UINavigationController.self)){
                let navigationController = topViewController as! UINavigationController
                topViewController = navigationController.topViewController!
            } else if (topViewController.isKind(of:UITabBarController.self)) {
                let tab = topViewController as! UITabBarController
                topViewController = tab.selectedViewController!
            } else {
                break
            }
        }
        return topViewController
    }
    public static var frontWindow: UIWindow? {
        return UIApplication.shared.windows.reversed().first(where: {
            $0.screen == UIScreen.main &&
                !$0.isHidden && $0.alpha > 0 &&
                $0.windowLevel == UIWindow.Level.normal
        })
    }
}
