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
    class func upload(assets: [PHAsset],
                      complateHandler: @escaping (() -> Void),
                      falierHandler: @escaping ((PJNetwork.Error) -> Void)) {
        PJNetwork.shared.requstWithGet(path: URL.upload.rawValue,
                                       parameters: ["imageCount": String(assets.count)],
                                       complement: { (dataDict) in
                                        if dataDict["msgCode"]?.intValue == 0 {
                                            var dataDict = dataDict["msg"]!
                                            let tokens = dataDict["upload_tokens"].arrayValue
                                            var keys = ""
                                            var c_index = 0
                                            for c_i in 0..<assets.count {
                                                QNUploadManager()?.put(assets[c_i], key: nil, token: tokens[c_i].string, complete: { (info, key, respDict) in
                                                    guard let `respDict` = respDict else { return }
                                                    // key 即为文件名
                                                    let key = respDict["key"]
                                                    keys += "," + String(key as! String)
                                                    c_index += 1
                                                    
                                                    if c_index == assets.count {
                                                        keys.removeFirst()
                                                        setKey(key: keys, complateHandler: { (imgUrls) in
                                                            // TODO: 还是有些问题，需要搞懂七牛云对私有空间怎么下载
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
        
        /// 上传 keys 且换回图片完整 url
        func setKey(key: String,
                    complateHandler: @escaping ((([String]) -> Void)),
                    failuredHandler: @escaping ((PJNetwork.Error) -> Void)) {
            PJNetwork.shared.requstWithPost(path: URL.setKey.rawValue,
                                            parameters: ["keys": key],
                                            complement: { (dataDict) in
                                                if dataDict["msgCode"]?.intValue == 0 {
                                                    var dataDict = dataDict["msg"]!
                                                    let keys = dataDict["image_urls"].string
                                                    if keys != nil {
                                                        let ks = keys!.split(separator: ",")
                                                        var k = [String]()
                                                        for key in ks {
                                                            k.append(String(key))
                                                        }
                                                        complateHandler(k)
                                                    }
                                                }
            }) { (errorString) in
                let error = PJNetwork.Error(errorCode: nil, errorMsg: errorString)
                falierHandler(error)
            }
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
