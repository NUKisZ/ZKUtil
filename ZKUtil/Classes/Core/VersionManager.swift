//
//  VersionManager.swift
//  LoveDiary
//
//  Created by ZhangKun on 2019/2/19.
//  Copyright © 2019 张坤. All rights reserved.
//

import UIKit

struct VersionInfo {
    var url: String        //下载应用URL
    var title: String       //title
    var message: String       //提示内容
    var must_update: Bool  //是否强制更新
    var version: String     //版本
    var build: String       //build
}

class VersionManager: NSObject {

    ///本地版本
    private static func localVersion() -> String{
        return kAppVersion
    }
    private static func localBuild() -> String{
        return kAppBuildVersion
    }

    static func versionUpdate() {
        //1 请求服务端数据，并进行解析,得到需要的数据
        //2 版本更新
//        Tools.httpRequest(api: .appVersion, successClouse: { (json) in
//            print(json)
//            let data = json["data"]
//            guard let ios_message = data["message"].string,
//            let ios_title = data["title"].string,
//            let ios_build = data["build"].string,
//            //let id = data["id"].int,
//            let ios_version = data["version"].string,
//            let ios_must_update = data["must_update"].bool,
//            let ios_url = data["url"].string
//                else {return}
//            let info = VersionInfo(url: ios_url, title: ios_title, message: ios_message, must_update: ios_must_update, version: ios_version, build: ios_build)
//            //自己公司服务器获取到的数据与APP对比
//            handleUpdate(info)
//        }) { (info, code) in
//            print(info)
//        }
//        handleUpdate(VersionInfo(url: "https://itunes.apple.com/cn/app/m-help/id1423515569?mt=8", title: "有新版本啦！", message: "提示更新内容，解决了xxx等一系列问题，新增了xxx等功能！", must_update: true, version: "1.0.0",build:"1"))
    }

    /// 版本更新
    static func handleUpdate(_ info: VersionInfo) {
        if isIgnoreCurrentVersionUpdate(info.version) { return }
        if versionAndBuildCompare(localVersion: localVersion(), serverVersion: info.version,localBuild:localBuild(),serverBuild:info.build){
            let alert = UIAlertController(title: info.title, message: info.message, preferredStyle: .alert)
            let update = UIAlertAction(title: "立即更新", style: .default, handler: { action in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: info.url)!)
                } else {
                    if UIApplication.shared.canOpenURL(URL(string: info.url)!){
                        UIApplication.shared.openURL(URL(string: info.url)!)
                    }
                }
            })
            alert.addAction(update)
            if !info.must_update { //是否强制更新
                let cancel = UIAlertAction(title: "忽略此版本", style: .cancel, handler: { action in
                    UserDefaults.standard.set(info.version, forKey: "IgnoreCurrentVersionUpdate")
                })
                alert.addAction(cancel)
            }
            if let vc = UIApplication.shared.keyWindow?.rootViewController {
                vc.present(alert, animated: true, completion: nil)
            }
        }
    }

    // 版本比较
    private static func versionCompare(localVersion: String, serverVersion: String) -> Bool {
        let result = localVersion.compare(serverVersion, options: .numeric, range: nil, locale: nil)
        if result == .orderedDescending || result == .orderedSame{
            return false
        }
        return true
    }
    // build版本比较
    private static func versionAndBuildCompare(localVersion: String, serverVersion: String,localBuild:String,serverBuild:String)->Bool{
        let resultVersion = localVersion.compare(serverVersion, options: .numeric, range: nil, locale: nil)
        if resultVersion == .orderedDescending {
            return false
        } else if resultVersion == .orderedSame{
            let resultBuild = localBuild.compare(serverBuild, options: .numeric, range: nil, locale: nil)
            if resultBuild == .orderedDescending || resultBuild == .orderedSame{
                return false
            }
            return true
        }
        return true
    }

    // 是否忽略当前版本更新
    private static func isIgnoreCurrentVersionUpdate(_ version: String) -> Bool {
        return UserDefaults.standard.string(forKey: "IgnoreCurrentVersionUpdate") == version
    }
}
