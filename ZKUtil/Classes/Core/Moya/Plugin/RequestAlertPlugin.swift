//
//  RequestAlertPlugin.swift
//  HKWX
//
//  Created by 张坤 on 2018/1/11.
//  Copyright © 2018年 张坤 All rights reserved.
//

#if canImport(Result)
import Result
#endif
#if canImport(Result)
final class RequestAlertPlugin: PluginType{
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        
        if case let .success(response) = result,response.statusCode == 200 {
            return
        }
        Tools.showToast(toast: "网络请求失败,请稍后重试")
        if case let .success(response) = result{
            print("访问网址:\n",response.request?.url?.absoluteString ?? "url","\n错误代码",response.statusCode)
        } else if case let .failure(error) = result{
            switch error{
            case .underlying(let err, _):
                let nsErr = err as NSError
                let url = nsErr.userInfo["NSErrorFailingURLStringKey"] ?? "url is nil"
                print("访问网址:\n",url,"\n错误代码",nsErr.code,error.errorDescription ?? "error")
            default:
                print(error)
            }
        }
        
    }
}
#endif
