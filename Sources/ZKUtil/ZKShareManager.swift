//
//  ZKShareManager.swift
//  MicroVote
//
//  Created by gongrong on 2018/4/28.
//  Copyright © 2018年 张坤. All rights reserved.
//

import UIKit
#if canImport(WechatKit)
import WechatKit
#endif
enum ShareType:Int {
    case wechat
    case timeline
    case qq
    case qzone
    case weibo
}
class ZKShareManager: NSObject {
    open private(set) var type:ShareType = .wechat
    private var successClosure:ZKSocialClosure?
    private var errorClsure:ZKSocialClosure?
    private var title:String?
    private var desc:String?
    private var image:UIImage?
    private var imageUrl:String?
    private var url:String?
    static var share = ZKShareManager()
    private override init() {
        super.init()
    }
    func share(type:ShareType = .wechat,title:String?,desc:String?,image:UIImage?,imageUrl:String?,url:String?,successClosure:@escaping ZKSocialClosure,errorClsure:@escaping ZKSocialClosure) {
        self.type = type
        if type == .wechat || type == .timeline{
            ZKSocialHelper.share.socialType = .wechat
        } else if type == .weibo{
            ZKSocialHelper.share.socialType = .weibo
        } else if type == .qq || type == .qzone{
            ZKSocialHelper.share.socialType = .qq
        }
        self.successClosure = successClosure
        self.errorClsure = errorClsure
        self.title = title
        self.desc = desc
        self.image = image
        self.imageUrl = imageUrl
        self.url = url
        switch type {
        case .wechat:
            shareWechat(scene: 0)
        case .timeline:
            shareWechat(scene: 1)
        default:
            break
        }
    }
    private func shareWechat(scene:Int = 0){
        #if canImport(WechatKit)

        let message = WXMediaMessage()
        if let it = title{
            message.title = it
        }
        if let de = desc{
            message.description = de
        }
        if let im = image{
            message.setThumbImage(im)
        }
        if let ur = url{
            let webPageObject = WXWebpageObject()
            webPageObject.webpageUrl = ur
            message.mediaObject = webPageObject
        } else {
            let path = Bundle.main.path(forResource: "1024icon", ofType: "png")
            if let pat = path{
                let imageObject = WXImageObject()
                let image = UIImage(contentsOfFile: pat)
                let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
                let att1 = NSAttributedString(string: title! + "\n", attributes: [ NSAttributedStringKey.backgroundColor : UIColor.clear,NSAttributedStringKey.foregroundColor : UIColor.red, NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 120)])
                let att2 = NSAttributedString(string: "我在免费使用，使用邀请码", attributes: [ NSAttributedStringKey.backgroundColor : UIColor.clear,NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 120)])
                let att3 = NSAttributedString(string: title!, attributes: [ NSAttributedStringKey.backgroundColor : UIColor.clear,NSAttributedStringKey.foregroundColor : UIColor.red, NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 120)])
                let att4 = NSAttributedString(string: "激活，可获取5天免费时长哦~", attributes: [ NSAttributedStringKey.backgroundColor : UIColor.clear,NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 120)])
                attributedStrM.append(att1)
                attributedStrM.append(att2)
                attributedStrM.append(att3)
                attributedStrM.append(att4)
                let im = image?.drawTextInImage(text: attributedStrM)
                imageObject.imageData = im?.compressedData()
                message.mediaObject = imageObject
            }
            
        }
        
        let req = SendMessageToWXReq()
        req.message = message
        req.bText = false
        if scene == 0{
            req.scene = Int32(UInt32(WXSceneSession.rawValue))
        } else {
            req.scene = Int32(UInt32(WXSceneTimeline.rawValue))
        }
        
        WXApi.send(req)
        #endif
    }
    #if canImport(WechatKit)
    func callBack(_ resp: BaseResp!){
        if resp.errCode == 0{
            if successClosure != nil{
                successClosure!("分享成功",Int(resp.errCode))
            }
        } else {
            if errorClsure != nil{
                errorClsure!("分享失败",Int(resp.errCode))
            }
        }
        print(resp.errStr)
    }
    #endif
    
    
}
