//
//  ZKProvider.swift
//  LoveDiary
//
//  Created by 张坤 on 2019/7/16.
//  Copyright © 2019 张坤. All rights reserved.
//

import UIKit
#if canImport(RxSwift) && canImport(RxCocoa)

import RxSwift
import RxCocoa

class ZKProvider: MoyaProvider<MultiTarget> {
    let disposeBag:DisposeBag = DisposeBag()

    override init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure, requestClosure: @escaping MoyaProvider<Target>.RequestClosure, stubClosure: @escaping MoyaProvider<Target>.StubClosure, callbackQueue: DispatchQueue?, manager: Manager, plugins: [PluginType], trackInflights: Bool) {
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, manager: manager, plugins: plugins, trackInflights: trackInflights)
    }
}
extension ZKProvider{
    func request<T:Mappable,U:TargetType>(target:U)-> Observable<T>{
        let t = self.rx.request(target as! MultiTarget)
            .filterSuccessfulStatusCodes()
            .asObservable()
            .filterSuccess(disposeBag: disposeBag, target: target as! MultiTarget)
            .mapObject(T.self)
        return t

    }
}
#endif
