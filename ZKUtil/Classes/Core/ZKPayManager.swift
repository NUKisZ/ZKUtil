//
//  ZKPayManager.swift
//  MicroVote
//
//  Created by gongrong on 2018/5/3.
//  Copyright © 2018年 张坤. All rights reserved.
//

import UIKit
#if canImport(WechatKit)
import WechatKit
#endif
enum PayType:Int {
    case wechatpay
    case alipay
}
class ZKPayManager: NSObject {
    static var share = ZKPayManager()
    private var type:PayType = .wechatpay
    private var successClosure:ZKSocialClosure?
    private var errorClsure:ZKSocialClosure?
    private var paramter:[String:Any]!
    private override init() {
        super.init()
    }
    func pay(payType:PayType,paramter:[String:Any],success:@escaping ZKSocialClosure,failer:@escaping ZKSocialClosure){
        self.type = payType
        if payType == .wechatpay{
            ZKSocialHelper.share.socialType = .wechat
        } else {
            ZKSocialHelper.share.socialType = .alipay
        }
        self.paramter = paramter
        self.successClosure = success
        self.errorClsure = failer
        if payType == .wechatpay{
            wechatPay()
        } else if payType == .alipay{
            
        }
    }
    private func wechatPay(){
        #if canImport(WechatKit)
        let request = PayReq()
        request.partnerId = paramter["partnerid"] as! String
        request.prepayId = paramter["prepayid"] as! String
        request.package = paramter["package"] as! String
        request.nonceStr = paramter["noncestr"] as! String
        request.timeStamp = UInt32((paramter["timestamp"] as! String))!
        request.sign = paramter["sign"] as! String
        WXApi.send(request)
        #endif
    }
    #if canImport(WechatKit)
    func callBack(_ resp: BaseResp!){
        if resp.errCode == 0{
            if successClosure != nil{
                successClosure!("支付成功",Int(resp.errCode))
            }
        } else {
            if errorClsure != nil{
                errorClsure!("支付失败",Int(resp.errCode))
            }
        }
        print(resp.errStr)
    }
    #endif

}
