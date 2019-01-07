//
//  PJImageUpload.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/1/2.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import Foundation
import Photos
import Qiniu

class PJImageUploader {
    /// 上传图片
    class func upload(assets: [PHAsset],
                      complateHandler: @escaping (([String], [String]) -> Void),
                      falierHandler: @escaping ((PJNetwork.Error) -> Void)) {
        PJNetwork.shared.requstWithGet(path: URL.upload.rawValue,
                                       parameters: ["imageCount": String(assets.count)],
                                       complement: { (dataDict) in
                                        if dataDict["msgCode"]?.intValue == 0 {
                                            var dataDict = dataDict["msg"]!
                                            let tokens = dataDict["upload_tokens"].arrayValue
                                            // `setKey` 方法参数
                                            var keys = ""
                                            // complateHandler 闭包回调参数
                                            var complateKeys = [String]()
                                            for c_i in 0..<assets.count {
                                                let token = tokens[c_i]["img_token"].string
                                                let key = tokens[c_i]["img_key"].string
                                                complateKeys.append(key!)
                                                // 七牛上传
                                                QNUploadManager()?.put(assets[c_i],
                                                                       key: key,
                                                                       token: token,
                                                                       complete: { (info, key, respDict) in
                                                                        guard let respDict = respDict else { return }
                                                                        // key 即为文件名。拼接完成后一次性丢给 API
                                                                        let key = respDict["key"]
                                                                        keys += "," + String(key as! String)
                                                    
                                                                        if c_i == assets.count - 1 {
                                                                            keys.removeFirst()
                                                                            setKey(key: keys, complateHandler: { (imgUrls) in
                                                                                complateHandler(imgUrls, complateKeys)
                                                                            }, failuredHandler: { (error) in
                                                                                falierHandler(error)
                                                                            })
                                                                        }
                                                }, option: nil)
                                            }
                                        } else {
                                            let error = PJNetwork.Error(errorCode: dataDict["msgCode"]?.intValue,
                                                                        errorMsg: dataDict["msg"]?.string)
                                            falierHandler(error)
                                        }
        }) { (errorString) in
            falierHandler(PJNetwork.Error(errorCode: nil, errorMsg: errorString))
        }
    }
    
    /// 通过 拼接完后的所有 keys 换回图片完整 url
    class func setKey(key: String,
                complateHandler: @escaping ((([String]) -> Void)),
                failuredHandler: @escaping ((PJNetwork.Error) -> Void)) {
        PJNetwork.shared.requstWithPost(path: URL.setKey.rawValue,
                                        parameters: ["keys": key],
                                        complement: { (dataDict) in
                                            if dataDict["msgCode"]?.intValue == 0 {
                                                var dataDict = dataDict["msg"]!
                                                let keys = dataDict["image_urls"].array
                                                if keys != nil {
                                                    var k = [String]()
                                                    for key in keys! {
                                                        k.append(key.string!)
                                                    }
                                                    complateHandler(k)
                                                }
                                            }
        }) { (errorString) in
            let error = PJNetwork.Error(errorCode: nil, errorMsg: errorString)
            failuredHandler(error)
        }
    }
}

// MARK: - URL
extension PJImageUploader {
    enum URL: String {
        case upload = "realPet/uploadToken"
        case setKey = "realPet/setKeys"
    }
}
