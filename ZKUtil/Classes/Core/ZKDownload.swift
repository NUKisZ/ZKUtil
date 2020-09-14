//
//  ZKDownload.swift
//  ZKUtil
//
//  Created by 张坤 on 2019/7/24.
//  Copyright © 2019 张坤. All rights reserved.
//

import Foundation
public struct BaseError:Error {
    var code:Int = 0
    var desc:String = ""
}
public enum ZKDownloaderType:Int{
    case `default` = 0
}
public protocol ZKDownloaderDelegate:NSObjectProtocol{
    func downloader(_ download:ZKDownloader,didFailWithError error:NSError)
    func downloader(_ download:ZKDownloader,didFinishWithData data:Data?)
    //    @objc optional func downloader(_ download:ZKDownloader,didCan cancel:String)
}
extension ZKDownloaderDelegate{
    func downloader(_ download:ZKDownloader,didFailWithError error:NSError){
        print("downloader didFailWithError")
    }
    func downloader(_ download:ZKDownloader,didFinishWithData data:Data?){
        print("downloader didFinishWithData")
    }
}
open class ZKDownloader: NSObject {

    open weak var delegate:ZKDownloaderDelegate?
    //var type:ZKDownloaderType?
    open var type:Int?
    // MARK: - 代理方式封装URLSession的下载
    open func getWithUrl(_ urlString:String){
        let session = URLSession.shared
        guard let url = URL(string: urlString) else {return}
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil{
                self.delegate?.downloader(self, didFailWithError: error! as NSError)
            } else {
                //根据状态码区分
                let httpRes = response as! HTTPURLResponse
                if httpRes.statusCode == 200{
                    //正确返回
                    self.delegate?.downloader(self, didFinishWithData: data)
                    
                } else {
                    //500之类的错误
                    let erro = NSError(domain: "下载错误", code: httpRes.statusCode, userInfo: nil)
                    self.delegate?.downloader(self, didFailWithError: erro)
                }
            }
        }
        task.resume()

    }
    open func postWithUrl(urlString:String,params:[String:String]){
        let url = URL(string: urlString)
        var request = URLRequest(url: url! as URL)
        let dict = NSDictionary(dictionary: params)
        var paramString = String()

        if dict.allKeys.count > 0 {

            for i in 0..<dict.allKeys.count {
                //获取字典的每一个键值对
                let key = dict.allKeys[i] as! String
                let value = dict[key] as! String

                if i == 0 {
                    paramString = paramString.appendingFormat("%@=%@", key, value)
                } else {
                    paramString = paramString.appendingFormat("&%@=%@", key, value)
                }
            }

        }

        let data = paramString.data(using: String.Encoding.utf8, allowLossyConversion: true)
        request.httpBody = data
        request.httpMethod = "POST"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                //下载失败
                self.delegate?.downloader(self, didFailWithError: err as NSError)
            } else {

                let httpRes = response as! HTTPURLResponse
                if httpRes.statusCode == 200 {
                    //下载成功

                    self.delegate?.downloader(self, didFinishWithData: data)

                } else {
                    let erro = NSError(domain: "下载错误", code: httpRes.statusCode, userInfo: nil)
                    self.delegate?.downloader(self, didFailWithError: erro)
                }

            }
        }
        task.resume()

    }

    // MARK: - 闭包方式封装URLSession的下载
    open class func getWithClosure(urlString: String, failClosure: @escaping ((Error?) -> Void), successClosure: @escaping ((Data) -> Void)){

        //1.NSURL
        let url = URL(string: urlString)
        //2.NSURLRequest
        let request = URLRequest(url: url!)
        //3.NSURLSession
        let session = URLSession.shared
        //4.task
        let task = session.dataTask(with: request) { (data, response, error) in

            if error != nil {
                //失败
                failClosure(error!)
            } else {

                let httpRes = response as! HTTPURLResponse
                if httpRes.statusCode == 200 {
                    //成功
                    DispatchQueue.main.async {
                        successClosure(data!)
                    }

                } else {
                    //失败
                    var error = BaseError()
                    error.code = httpRes.statusCode
                    error.desc = urlString
                    DispatchQueue.main.async {
                        failClosure(error)
                    }

                }


            }

        }

        //5.开始下载
        task.resume()

    }

    open class func postWithClosure(urlString:String,params:[String:String], failClosure: @escaping ((Error?) -> Void), successClosure: @escaping ((Data) -> Void)){
        let url = URL(string: urlString)
        var request = URLRequest(url: url! as URL)
        
        
//        字典转url拼接
//        var paramString = String()
//
//        paramString = params.compactMap({ (key, value) -> String in
//            return "\(key)=\(value)"
//        }).joined(separator: "&")
//
//        let data = paramString.data(using: String.Encoding.utf8, allowLossyConversion: true)
//        print(data?.count as Any)
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: params)
            
            request.httpBody = jsonData
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (data, response, error) in
                if let err = error {
                    //下载失败
                    failClosure(err)
                } else {
                    
                    let httpRes = response as! HTTPURLResponse
                    if httpRes.statusCode == 200 {
                        //下载成功
                        successClosure(data!)
                        
                    } else {
                        let erro = NSError(domain: "下载错误", code: httpRes.statusCode, userInfo: nil)
                        failClosure(erro)
                    }
                    
                }
            }
            task.resume()
        }catch{
            failClosure(error)
        }

    }

}
