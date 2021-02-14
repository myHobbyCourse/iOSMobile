//
//  Webservice.swift
//  Webservice
//
//  Created by Nitin on 6/18/18.
//  Copyright © 2018 Nitin. All rights reserved.
//

import Foundation
import UIKit
typealias Parameters = [String: Any]
typealias RequestCompletion = (_ reply:String?,_ response:[String:Any],_ error:Error?,_ statuscode : Int?)->()

class ApiManagerURLSession {
    //MARK:- url Encoded Function
    class func CreateAndGetRes(url:String,method:httpMetod,dictHeader:[String:String]? = ["Content-Type":"application/json"],dictParameter:Parameters?,completionHandler completion: @escaping RequestCompletion){

            if method == .GET{
                var components = URLComponents(string: url)
                if let dictparam = dictParameter {
                    for (key,value) in dictparam {
                        let item = URLQueryItem(name: key ,value: value as? String)
                        components?.queryItems?.append(item)
                    }
                }
                guard let url = components?.url else{
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.timeoutInterval = 60
                request.setValue(ContentType.Application_Json.rawValue, forHTTPHeaderField: "Content-Type")
                if let header = dictHeader {
                    for (key,value) in header {
                        request.setValue(value, forHTTPHeaderField: key)
                    }
                }
                ApiManagerURLSession.getRes(request: request, completion: completion)
            }else if method == .POST{
                guard let url = URL(string:url) else{return}
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue(ContentType.Application_Json.rawValue, forHTTPHeaderField: "Content-Type")
                request.timeoutInterval = 60
                guard let body = try? JSONSerialization.data(withJSONObject: dictParameter ?? [:], options: [])else{
                    return
                }

                request.httpBody = body
                if let header = dictHeader {
                    for (key,value) in header{
                        request.setValue(value, forHTTPHeaderField: key)
                    }
                }

                ApiManagerURLSession.getRes(request: request, completion: completion)
            }
        else{
              //  appDelegate.alertWithMessage(msg: WSConstant.internetConnection)
         //   appDelegate.presentAlertContoller(tag: 3, title: nil, subTitle: nil)
        }
    }
    
     //MARK:- MultiPart Function
    class func CreateAndGetResMultiPart(url:String,method:httpMetod,dictHeader:[String:String]?,dictParameter:Parameters?,completionHandler completion: @escaping RequestCompletion){
               if Network.reachability.isReachable{
            guard let myUrl = URL(string : url) else { return }
            var request = URLRequest(url: myUrl)
            request.httpMethod = method == .POST ? "POST" : "GET"
            request.timeoutInterval = 60

            let boundary = generateBoundary()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            if let parameters = dictParameter {
                let dataBody = createDataBody(withParameters: parameters as? [String : String], media: [], boundary: boundary)
//                let str = String(data: dataBody, encoding: .utf8)
//                //print(str)
                request.httpBody = dataBody
            }
            if let header = dictHeader {
                //print(request.allHTTPHeaderFields!)
                for (key,value) in header {
                    request.addValue(value , forHTTPHeaderField: key)
                }
            }
        //print(request.allHTTPHeaderFields!)  
        
            self.getRes(request: request, completion: completion)
  
        }
    }
    class func CreateAndGetResMultiPartMedia(url:String,method:httpMetod,dictHeader:[String:String]?,dictParameter:Parameters?,media:[Media],completionHandler completion: @escaping RequestCompletion){
        if Network.reachability.isReachable{
            guard let myUrl = URL(string : url) else { return }
            var request = URLRequest(url: myUrl)
            request.httpMethod  = "POST"//= method == .POST ? "POST" : "GET"
            request.timeoutInterval = 60
            let boundary = generateBoundary()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            guard let parameters = dictParameter else {
                return
            }
            let dataBody = createDataBody(withParameters: parameters as? [String : String], media: media, boundary: boundary)
            request.httpBody = dataBody


            if let header = dictHeader {
                //print(request.allHTTPHeaderFields!)
                for (key,value) in header {
                    request.addValue(value , forHTTPHeaderField: key)
                }
            }
            //print(request.allHTTPHeaderFields!)
            self.getRes(request: request, completion: completion)
        }
    }


    
  
     class func getRes(request:URLRequest,completion:@escaping RequestCompletion){
        let task = URLSession.shared.dataTask(with: request) { (data, response, err) in

            //print(data ?? "",err ?? "",response ?? "")
            var reply : String?
            var urlResponse : HTTPURLResponse?
            if let res:HTTPURLResponse = response as? HTTPURLResponse {
                urlResponse = res
            }
            if let data = data {
                do {
                    reply = String(data: data, encoding: String.Encoding.utf8)
                    if let jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.init(rawValue: 2)) as? [Any] {
                        DispatchQueue.main.async {
                            completion(reply, ["data":jsonData], err, urlResponse?.statusCode)
                        }
                    }else if let jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.init(rawValue: 2)) as? [String:Any] {
                        DispatchQueue.main.async {
                            completion(reply, jsonData, err, urlResponse?.statusCode)
                        }
                    }
                }catch{
                    DispatchQueue.main.async {
                        completion(reply, ["message":error.localizedDescription], err, 400)
                    }
                }
            }
            
            if let error = err{
                DispatchQueue.main.async {
                     completion(error.localizedDescription, ["message":error.localizedDescription], err, 400)
                }

            }
        }
        
        task.resume()
    }
    
    
    
    class func createDataBody(withParameters params: [String:String]?, media: [Media]?, boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=files; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
    
    class func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}

enum httpMetod{
    case PUT
    case GET
    case POST
}
//
enum ContentType : String{
    case urlEncoded  = "application/x-www-form-urlencoded;charset=UTF-8"
    case Application_Json = "application/json"
    case multipartFormData = "multipart/form-data"
}
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
import AVFoundation
struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "\(Int64(Date().timeIntervalSince1970 * 1000))"
        guard let data = UIImageJPEGRepresentation(image, 0.1) else { return nil }
        self.data = data
    }
    
    init?(withFile fileUrl: URL, forKey key: String) {
            self.key = key
            self.mimeType = MimeType.init(url: fileUrl).value
            let ext = MimeType.init(url: fileUrl).ext
            self.filename = "ideal.\(String(describing: ext))"
            guard let data = try? Data.init(contentsOf: fileUrl) else {
                return nil
            }
            self.data = data
    }


}

let DEFAULT_MIME_TYPE = "application/octet-stream"
let mimeTypes = [
    "html": "text/html",
    "htm": "text/html",
    "shtml": "text/html",
    "css": "text/css",
    "xml": "text/xml",
    "gif": "image/gif",
    "jpeg": "image/jpeg",
    "jpg": "image/jpeg",
    "js": "application/javascript",
    "atom": "application/atom+xml",
    "rss": "application/rss+xml",
    "mml": "text/mathml",
    "txt": "text/plain",
    "jad": "text/vnd.sun.j2me.app-descriptor",
    "wml": "text/vnd.wap.wml",
    "htc": "text/x-component",
    "png": "image/png",
    "tif": "image/tiff",
    "tiff": "image/tiff",
    "wbmp": "image/vnd.wap.wbmp",
    "ico": "image/x-icon",
    "jng": "image/x-jng",
    "bmp": "image/x-ms-bmp",
    "svg": "image/svg+xml",
    "svgz": "image/svg+xml",
    "webp": "image/webp",
    "woff": "application/font-woff",
    "jar": "application/java-archive",
    "war": "application/java-archive",
    "ear": "application/java-archive",
    "json": "application/json",
    "hqx": "application/mac-binhex40",
    "doc": "application/msword",
    "pdf": "application/pdf",
    "ps": "application/postscript",
    "eps": "application/postscript",
    "ai": "application/postscript",
    "rtf": "application/rtf",
    "m3u8": "application/vnd.apple.mpegurl",
    "xls": "application/vnd.ms-excel",
    "eot": "application/vnd.ms-fontobject",
    "ppt": "application/vnd.ms-powerpoint",
    "wmlc": "application/vnd.wap.wmlc",
    "kml": "application/vnd.google-earth.kml+xml",
    "kmz": "application/vnd.google-earth.kmz",
    "7z": "application/x-7z-compressed",
    "cco": "application/x-cocoa",
    "jardiff": "application/x-java-archive-diff",
    "jnlp": "application/x-java-jnlp-file",
    "run": "application/x-makeself",
    "pl": "application/x-perl",
    "pm": "application/x-perl",
    "prc": "application/x-pilot",
    "pdb": "application/x-pilot",
    "rar": "application/x-rar-compressed",
    "rpm": "application/x-redhat-package-manager",
    "sea": "application/x-sea",
    "swf": "application/x-shockwave-flash",
    "sit": "application/x-stuffit",
    "tcl": "application/x-tcl",
    "tk": "application/x-tcl",
    "der": "application/x-x509-ca-cert",
    "pem": "application/x-x509-ca-cert",
    "crt": "application/x-x509-ca-cert",
    "xpi": "application/x-xpinstall",
    "xhtml": "application/xhtml+xml",
    "xspf": "application/xspf+xml",
    "zip": "application/zip",
    "bin": "application/octet-stream",
    "exe": "application/octet-stream",
    "dll": "application/octet-stream",
    "deb": "application/octet-stream",
    "dmg": "application/octet-stream",
    "iso": "application/octet-stream",
    "img": "application/octet-stream",
    "msi": "application/octet-stream",
    "msp": "application/octet-stream",
    "msm": "application/octet-stream",
    "docx": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    "xlsx": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    "pptx": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
    "mid": "audio/midi",
    "midi": "audio/midi",
    "kar": "audio/midi",
    "mp3": "audio/mpeg",
    "ogg": "audio/ogg",
    "m4a": "audio/x-m4a",
    "ra": "audio/x-realaudio",
    "3gpp": "video/3gpp",
    "3gp": "video/3gpp",
    "ts": "video/mp2t",
    "mp4": "video/mp4",
    "mpeg": "video/mpeg",
    "mpg": "video/mpeg",
    "mov": "video/quicktime",
    "webm": "video/webm",
    "flv": "video/x-flv",
    "m4v": "video/x-m4v",
    "mng": "video/x-mng",
    "asx": "video/x-ms-asf",
    "asf": "video/x-ms-asf",
    "wmv": "video/x-ms-wmv",
    "avi": "video/x-msvideo"
]

public struct MimeType {
    let ext: String?
    public var value: String {
        guard let ext = ext else {
            return DEFAULT_MIME_TYPE
        }
        return mimeTypes[ext.lowercased()] ?? DEFAULT_MIME_TYPE
    }
    public init(path: String) {
        ext = NSString(string: path).pathExtension
    }
    
    public init(path: NSString) {
        ext = path.pathExtension
    }
    
    public init(url: URL) {
        ext = url.pathExtension
    }
}







import Foundation
import SystemConfiguration

class Reachability {
    var hostname: String?
    var isRunning = false
    var isReachableOnWWAN: Bool
    var reachability: SCNetworkReachability?
    var reachabilityFlags = SCNetworkReachabilityFlags()
    let reachabilitySerialQueue = DispatchQueue(label: "ReachabilityQueue")
    init(hostname: String) throws {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, hostname) else {
            throw Network.Error.failedToCreateWith(hostname)
        }
        self.reachability = reachability
        self.hostname = hostname
        isReachableOnWWAN = true
        try start()
    }
    init() throws {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let reachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            throw Network.Error.failedToInitializeWith(zeroAddress)
        }
        self.reachability = reachability
        isReachableOnWWAN = true
        try start()
    }
    var status: Network.Status {
        return  !isConnectedToNetwork ? .unreachable :
            isReachableViaWiFi    ? .wifi :
            isRunningOnDevice     ? .wwan : .unreachable
    }
    var isRunningOnDevice: Bool = {
        #if targetEnvironment(simulator)
        return false
        #else
        return true
        #endif
    }()
    deinit { stop() }
}
extension Reachability {

    func start() throws {
        guard let reachability = reachability, !isRunning else { return }
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = Unmanaged<Reachability>.passUnretained(self).toOpaque()
        guard SCNetworkReachabilitySetCallback(reachability, callout, &context) else { stop()
            throw Network.Error.failedToSetCallout
        }
        guard SCNetworkReachabilitySetDispatchQueue(reachability, reachabilitySerialQueue) else { stop()
            throw Network.Error.failedToSetDispatchQueue
        }
        reachabilitySerialQueue.async { self.flagsChanged() }
        isRunning = true
    }

    func stop() {
        defer { isRunning = false }
        guard let reachability = reachability else { return }
        SCNetworkReachabilitySetCallback(reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
        self.reachability = nil
    }

    var isConnectedToNetwork: Bool {
        return isReachable &&
            !isConnectionRequiredAndTransientConnection &&
            !(isRunningOnDevice && isWWAN && !isReachableOnWWAN)
    }

    var isReachableViaWiFi: Bool {
        return isReachable && isRunningOnDevice && !isWWAN
    }

    /// Flags that indicate the reachability of a network node name or address, including whether a connection is required, and whether some user intervention might be required when establishing a connection.
    var flags: SCNetworkReachabilityFlags? {
        guard let reachability = reachability else { return nil }
        var flags = SCNetworkReachabilityFlags()
        return withUnsafeMutablePointer(to: &flags) {
            SCNetworkReachabilityGetFlags(reachability, UnsafeMutablePointer($0))
            } ? flags : nil
    }

    /// compares the current flags with the previous flags and if changed posts a flagsChanged notification
    func flagsChanged() {
        guard let flags = flags, flags != reachabilityFlags else { return }
        reachabilityFlags = flags
        NotificationCenter.default.post(name: .flagsChanged, object: self)
    }

    /// The specified node name or address can be reached via a transient connection, such as PPP.
    var transientConnection: Bool { return flags?.contains(.transientConnection) == true }

    /// The specified node name or address can be reached using the current network configuration.
    var isReachable: Bool { return flags?.contains(.reachable) == true }

    /// The specified node name or address can be reached using the current network configuration, but a connection must first be established. If this flag is set, the kSCNetworkReachabilityFlagsConnectionOnTraffic flag, kSCNetworkReachabilityFlagsConnectionOnDemand flag, or kSCNetworkReachabilityFlagsIsWWAN flag is also typically set to indicate the type of connection required. If the user must manually make the connection, the kSCNetworkReachabilityFlagsInterventionRequired flag is also set.
    var connectionRequired: Bool { return flags?.contains(.connectionRequired) == true }

    /// The specified node name or address can be reached using the current network configuration, but a connection must first be established. Any traffic directed to the specified name or address will initiate the connection.
    var connectionOnTraffic: Bool { return flags?.contains(.connectionOnTraffic) == true }

    /// The specified node name or address can be reached using the current network configuration, but a connection must first be established.
    var interventionRequired: Bool { return flags?.contains(.interventionRequired) == true }

    /// The specified node name or address can be reached using the current network configuration, but a connection must first be established. The connection will be established "On Demand" by the CFSocketStream programming interface (see CFStream Socket Additions for information on this). Other functions will not establish the connection.
    var connectionOnDemand: Bool { return flags?.contains(.connectionOnDemand) == true }

    /// The specified node name or address is one that is associated with a network interface on the current system.
    var isLocalAddress: Bool { return flags?.contains(.isLocalAddress) == true }

    /// Network traffic to the specified node name or address will not go through a gateway, but is routed directly to one of the interfaces in the system.
    var isDirect: Bool { return flags?.contains(.isDirect) == true }

    /// The specified node name or address can be reached via a cellular connection, such as EDGE or GPRS.
    var isWWAN: Bool { return flags?.contains(.isWWAN) == true }

    /// The specified node name or address can be reached using the current network configuration, but a connection must first be established. If this flag is set
    /// The specified node name or address can be reached via a transient connection, such as PPP.
    var isConnectionRequiredAndTransientConnection: Bool {
        return (flags?.intersection([.connectionRequired, .transientConnection]) == [.connectionRequired, .transientConnection]) == true
    }
}
func callout(reachability: SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?) {
    guard let info = info else { return }
    DispatchQueue.main.async {
        Unmanaged<Reachability>
            .fromOpaque(info)
            .takeUnretainedValue()
            .flagsChanged()
    }
}
extension Notification.Name {
    static let flagsChanged = Notification.Name("FlagsChanged")
}
struct Network {
    static var reachability: Reachability!
    enum Status: String {
        case unreachable, wifi, wwan
    }
    enum Error: Swift.Error {
        case failedToSetCallout
        case failedToSetDispatchQueue
        case failedToCreateWith(String)
        case failedToInitializeWith(sockaddr_in)
    }
}
