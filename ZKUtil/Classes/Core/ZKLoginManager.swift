//
//  ZKLoginManager.swift
//  GZ
//
//  Created by gongrong on 2018/5/7.
//  Copyright © 2018年 张坤. All rights reserved.
//

import UIKit
#if canImport(WechatKit)
import WechatKit
#endif
#if canImport(JSON)
import JSON
#endif
class ZKLoginManager: NSObject {
    static var share = ZKLoginManager()
    private var loginType:SocialType = .wechat
    private var success:ZKSocialClosure!
    private var failer:ZKSocialClosure!
    private override init() {
        super.init()
    }
    public func login(type:SocialType = .wechat,success:@escaping ZKSocialClosure,failer:@escaping ZKSocialClosure){
        loginType = type
        ZKSocialHelper.share.socialType = type
        self.success = success
        self.failer = failer
        switch type {
        case .wechat:
            wechat()
        default:
            break
        }
    }
    private func wechat(){
        #if canImport(WechatKit)
        if !WXApi.isWXAppInstalled() {
            //Tools.showToastWithCenter(toast: "未安装微信")
        } else {
            let req : SendAuthReq = SendAuthReq()
            req.scope = "snsapi_userinfo,snsapi_base"
            WXApi.send(req)
        }
        #endif
    }
    #if canImport(WechatKit)
    func callBack(_ resp: BaseResp!){
        let aresp = resp as! SendAuthResp
        //  var aresp1 = resp as? SendAuthResp
        
        if (aresp.errCode == 0)
        {
            print(aresp.code)
            //031076fd11ebfa5d32adf46b37c75aax
            guard let value = aresp.code else {
                failer("code为空",-999)
                return
            }
            getAccess_token(code: value)
        } else if (aresp.errCode == -4){
            failer("用户拒绝授权",-4)
        } else if (aresp.errCode == -2){
            failer("用户拒绝授权",-2)
        }
    }
    #endif
    //获取token
    private func getAccess_token(code :String){
        //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
        let appid = SocialConfig.wechatAppID
        let secret = SocialConfig.wechatAppSecret
        let requestUrl = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(appid)&secret=\(secret)&code=\(code)&grant_type=authorization_code"
        
        ZKDownloader.getWithClosure(urlString: requestUrl, failClosure: { (error) in
            print(error!)
        }) { [weak self](data) in
            #if canImport(JSON)
                let json = JSON(data)
                print(json)
                let access_token:String = json["access_token"].string!
                let openid:String = json["openid"].string!
                self?.getUserInfo(token: access_token, openid: openid)
            #endif
        }
        
    }
    
    //获取用户信息 第四步
    private func getUserInfo(token :String,openid:String){
        // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
        let requestUrl = "https://api.weixin.qq.com/sns/userinfo?access_token=\(token)&openid=\(openid)"
        ZKDownloader.getWithClosure(urlString: requestUrl, failClosure: { (error) in
            print(error!)
        }) { (data) in
//            let json = JSON(data)
//            print(json)
            
            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loginSuccess"), object: nil)
        }
    }
}
