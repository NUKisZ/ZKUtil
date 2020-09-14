//
//  ZKSocialHelper.swift
//  GZ
//
//  Created by gongrong on 2018/5/7.
//  Copyright © 2018年 张坤. All rights reserved.
//

import UIKit
#if canImport(WechatKit)
import WechatKit
#endif
struct SocialConfig {
    static let wechatAppID = ""
    static let wechatAppSecret = ""
}
enum SocialType:Int {
    case wechat
    case qq
    case weibo
    case alipay
}
typealias ZKSocialClosure = ((String,Int) -> Void)
class ZKSocialHelper: NSObject {
    static var share = ZKSocialHelper()
    public var socialType:SocialType = .wechat
    private override init() {
        super.init()
    }
    
    public func openUrl(url:URL) -> Bool{

        if url.description.hasPrefix("wx") || socialType == .wechat{
            #if canImport(WechatKit)
            return WXApi.handleOpen(url, delegate: self)
            #endif
        } else {
            
        }

        
        return true
    }
    
    
}
#if canImport(WechatKit)
extension ZKSocialHelper:WXApiDelegate{
    internal func onReq(_ req: BaseReq!) {
        print(req.description)
        //onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
    }
    internal func onResp(_ resp: BaseResp!) {
        print(resp.description)
        if resp.isMember(of: SendAuthResp.self) {
            //微信登录
            ZKLoginManager.share.callBack(resp)
            
        } else if resp.isMember(of: PayResp.self) {
            //微信支付
            ZKPayManager.share.callBack(resp)
        } else if resp.isMember(of: SendMessageToWXResp.self){
            //分享微信
            ZKShareManager.share.callBack(resp)
        }
        
    }
    

}
#endif
