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
}
