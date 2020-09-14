//
//  Tools.swift
//  GZ
//
//  Created by gongrong on 2017/11/20.
//  Copyright © 2017年 张坤. All rights reserved.
//

import UIKit
import SystemConfiguration
import SystemConfiguration.CaptiveNetwork
import NetworkExtension
//import KeychainAccess
import MobileCoreServices
import CommonCrypto
//判断真机还是模拟器
struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}
class Tools: NSObject {

    class func stringToMD5(string:String) -> String {
        let str = string.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(string.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize(count: digestLen)
        return String(format: hash as String)
    }
    
    public static func labelLineSpace(lineSpace:CGFloat=5,title:String) -> NSMutableAttributedString{
        let paraph = NSMutableParagraphStyle()
        //将行间距设置为28
        paraph.lineSpacing = lineSpace
        //paraph.alignment = .center
        //样式属性集合
        let attributedString = NSMutableAttributedString(string: title)
        let rang = NSRange(location: 0, length: title.count)
        attributedString.addAttributes([NSAttributedString.Key.paragraphStyle : paraph], range: rang)
        return attributedString
    }
    
    
    public static func getUsedSSID() -> String{
        let interfaces = CNCopySupportedInterfaces()
        var ssid = "无"
        if interfaces != nil {
            let interfacesArray = CFBridgingRetain(interfaces) as! [AnyObject]
            if interfacesArray.count > 0 {
                let interfaceName = interfacesArray[0] as! CFString
                let ussafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName)
                if (ussafeInterfaceData != nil) {
                    let interfaceData = ussafeInterfaceData as! [String: Any]
                    ssid = interfaceData["SSID"]! as! String
                    //                    let data = interfaceData["SSIDDATA"] as! Data
                    //                    let str = String(data: data, encoding: String.Encoding.utf8)
                    //                    print(str ?? "无")
                }
            }
        }
        return ssid
    }
    public static func GetIPAddresses() -> String? {
        var addresses = [String]()
        
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first
    }

//    class func getUUID()->String {
//        let chain = Keychain(service: "com.uilucky.tvdlan")
//        let UUID = chain["UUID"]
//        if UUID == nil {
//            let uuid = kDeviceUUID
//            chain["UUID"] = uuid
//            return uuid
//        } else {
//            return UUID!
//        }
//    }
    public static func dnsToIP(domainName: String) -> String {
        var result = ""
        let host = CFHostCreateWithName(nil,domainName as CFString).takeRetainedValue()
        CFHostStartInfoResolution(host, .addresses, nil)
        var success: DarwinBoolean = false
        if let addresses = CFHostGetAddressing(host, &success)?.takeUnretainedValue() as NSArray?,
            let theAddress = addresses.firstObject as? NSData {
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            if getnameinfo(theAddress.bytes.assumingMemoryBound(to: sockaddr.self), socklen_t(theAddress.length),
                           &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                let numAddress = String(cString: hostname)
                result = numAddress
            }
        }
        return result
    }
    public static func showAlert(vc:UIViewController,title:String?,message:String?,actionTitle:String?,handle: ((UIAlertAction)->Void)?,canceTitle:String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: handle)
        alert.addAction(action)
        if let cancelT = canceTitle {
            let cancel = UIAlertAction(title: cancelT, style: .cancel, handler: nil)
            alert.addAction(cancel)
        }
        vc.present(alert, animated: true, completion: nil)
    }
    //根据后缀获取对应的Mime-Type
    public static  func mimeType(pathExtension: String) -> String {
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                           pathExtension as NSString,
                                                           nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?
                .takeRetainedValue() {
                return mimetype as String
            }
        }
        //文件资源类型如果不知道，传万能类型application/octet-stream，服务器会自动解析文件类
        return "application/octet-stream"
    }
    //MARK:获取本地Documents路径
    ///获取本地Documents路径
    public static  func getDocumentsDirUrl(string:String)->URL{
        do{
            let documentsDir = try FileManager.default.url(for:.documentDirectory, in:.userDomainMask, appropriateFor:nil, create:true)
            let fileURL = URL(string:string, relativeTo:documentsDir)!
            return fileURL
        } catch {
            fatalError("\(error)")
        }
    }
    ///label高度
    public static func textHeight(_ text: String, width: CGFloat, font:UIFont) -> CGFloat {
        let constrainedSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let attributes = [ NSAttributedString.Key.font: font ]
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        let bounds = (text as NSString).boundingRect(with: constrainedSize, options: options, attributes: attributes, context: nil)
        return ceil(bounds.height)
    }
//    class func timeStringToShort(time:String)->String{
//        if time.count == "2019-01-26 16:06:11".count{
//            let date = time.date(withFormat: "yyyy-MM-dd HH:mm:ss")
//            let short = date?.string(withFormat: "MM-dd HH:mm")
//            return short ?? "11-11 11:11"
//        }
//        return time
//    }
    
    /// 是否设置了代理
    /// - Returns: true 代理了 false 没有设置代理
    public static func getProxyStatus() -> Bool{
        let dic = CFNetworkCopySystemProxySettings()!.takeUnretainedValue()
        let arr = CFNetworkCopyProxiesForURL(URL(string: "https://www.baidu.com")! as CFURL, dic).takeUnretainedValue()
        
        let obj = (arr as [AnyObject])[0]
        
        let host = obj.object(forKey: kCFProxyHostNameKey) ?? "null"
        let port = obj.object(forKey: kCFProxyPortNumberKey) ?? "null"
        let type = obj.object(forKey: kCFProxyTypeKey) ?? "null"
        
//        print(host)
//        print(port)
//        print(type)
        
        if obj.object(forKey: kCFProxyTypeKey) == kCFProxyTypeNone {
//            print("没有设置代理")
            return false
        } else {
//            print("设置代理了")
            return true
        }
    }
    
    /// 检查设备是否越狱
    /// - Returns: true false
    public static func isJailbroken() -> Bool {
        // 检查是否存在越狱常用文件
        let jailFilePaths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt"
        ]
        for filePath in jailFilePaths {
            if FileManager.default.fileExists(atPath: filePath) {
                return true
            }
        }

        // 检查是否安装了越狱工具Cydia
        if let url = URL(string: "cydia://package/com.example.package") {
            if UIApplication.shared.canOpenURL(url) {
                return true
            }
        }
        // 检查是否有权限读取系统应用列表
        if FileManager.default.fileExists(atPath: "/User/Applications/") {
            var applist: [String]? = nil
            do {
                applist = try FileManager.default.contentsOfDirectory(
                    atPath: "/User/Applications/")
            } catch {
            }
            print("applist = \(applist ?? [])")
            return true
        }
        //  检测当前程序运行的环境变量
        let env = getenv("DYLD_INSERT_LIBRARIES")
        print(env as Any)
        if env != nil{
            return true
        }

//        //  检测当前程序运行的环境变量
//        let env = (getenv("DYLD_INSERT_LIBRARIES") as NSString).utf8String
//        if env != nil {
//            return true
//        }

        return false
    }
}
