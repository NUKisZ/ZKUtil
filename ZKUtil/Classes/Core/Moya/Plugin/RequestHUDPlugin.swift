//
//  RequestHUFPlugin.swift
//  HKWX
//
//  Created by 张坤 on 2018/2/3.
//  Copyright © 2018年 张坤. All rights reserved.
//

import UIKit
#if canImport(Result)
import Result
#endif
#if canImport(Result)
class RequestHUDPlugin: PluginType {

    private let viewController: UIViewController
    public var title:String = "加载中..."
    public var failTitle:String = "加载失败"
    public var successTitle:String = "加载成功"

    private var progress: ProgressHUD!


    init(title:String = "加载中...",failTitle:String = "加载失败",successTitle:String = "加载成功") {
        viewController = UIWindow.currentViewController()
        ProgressHUD.showOnView(viewController.view, title: title, successTitle: successTitle, failTitle: failTitle)

    }


    func willSend(_ request: RequestType, target: TargetType) {


    }


    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        if case Result.failure(_) = result{
            ProgressHUD.hideAfterFailOnView(viewController.view)
        } else {
            ProgressHUD.hideAfterSuccessOnView(viewController.view)
        }
//        guard case Result.failure(error) = result else { return }
//        let message = error.errorDescription ?? "未知错误"
//        let alertViewController = UIAlertController(title: "请求失败",
//                                                    message: "\(message)",
//            preferredStyle: .alert)
//        alertViewController.addAction(UIAlertAction(title: "确定", style: .default,
//                                                    handler: nil))
//        viewController.present(alertViewController, animated: true)
    }

}
#endif
