//
//  KMoya+Extension.swift
//  LoveDiary
//
//  Created by 张坤 on 2019/7/17.
//  Copyright © 2019 张坤. All rights reserved.
//

import UIKit
#if canImport(Moya) && canImport(JSON)
import Moya
import JOSON
#endif

#if canImport(Moya) && canImport(JSON)
extension ObservableType where Element == Response {

    public func filterSuccess(disposeBag:DisposeBag,target:MultiTarget) -> Observable<Element> {
        return flatMap { (response) -> Observable<Element> in
            guard 200 ... 299 ~= response.statusCode else{
                //直接返回response的内容
                return Observable.just(response)
            }
            //处理过期(过期的code是后台定好的)
            let json = try? JSON(data: response.data).dictionaryValue
            guard let code = json?["status"]?.intValue else {
                return Observable.just(response)
            }
            //400  过期的code是后台定好的
            guard HttpStatusCode(rawValue: code) == HttpStatusCode.sys_success else {
                return Observable.just(response)
            }
            //缓存过期是请求的target
            UserManager.shared.needResendTarget = target
            //更新token
            let updateToken = TokenServices().updateToken()
            //
            updateToken.drive(onNext: { (json) in
                let ss = JSON(parseJSON: json)
                //替换本地的token
                print(ss["data"])
                print("Token失效,更新保存最新Token")
                UserManager.shared.token = ss["data"].string ?? ""
            }).disposed(by: disposeBag)
            //利用flatMapLatest把上一次缓存的target发送出去
            let updateTokenSuccess = updateToken.map{$0 != ""}
            let responses = updateTokenSuccess.asObservable().flatMapLatest { _ -> Observable<Response> in
                return APIProvider.rx.request(target).asObservable()
            }
            return responses
        }
    }
}
#endif
