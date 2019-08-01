//
//  RequestCachePlugin.swift
//  HKWX
//
//  Created by 张坤 on 2018/1/11.
//  Copyright © 2018年 张坤 All rights reserved.
//
//缓存插件  缓存时statusCode
public let kCacheStatusCode = 99999
public let kNetworkChangedNotification = "kNetworkChangedNotification"
#if canImport(Result)
import Result
#endif
#if canImport(Result)
final class RequestCachePlugin:PluginType{
    var url:String = ""
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {

        var request = request
        let flag = kUserDefaults.integer(forKey: kNetworkChangedNotification)
        if flag == 0{
            request.timeoutInterval = 1
        } else {
            request.timeoutInterval = kRequestTimeoutInterval
        }
        
        return request
    }
    func willSend(_ request: RequestType, target: TargetType) {

        url = "\(request)"
    }
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {

        if case let .success(response) = result{
            if response.statusCode == 200{
                let cache = ZKCache.sharedInstance
                cache.deleteCacheWithKey(key: url)
                cache.saveCacheWithData(cachedData: response.data, key: url)
            }
        }
    }
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {

        let result = result
        switch result {
        case .success(let response):
            if response.statusCode != 200{
                return readCache(result)
            } else {
                return result
            }
        case .failure:
            return readCache(result)
        }
    }
    private func readCache(_ result: Result<Response, MoyaError>)->Result<Response, MoyaError>{
        if kShouldCache{
            let cache = ZKCache.sharedInstance
            let data = cache.fetchCachedDataWithKey(key: url)
            if let dataCata = data{
                let response = Response(statusCode: kCacheStatusCode, data: dataCata)
                return .success(response)
            } else {
                return result
            }
        }
        return result
    }
}
#endif
