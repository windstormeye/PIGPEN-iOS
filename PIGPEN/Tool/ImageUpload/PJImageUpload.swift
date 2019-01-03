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
                                            for c_i in 0..<assets.count {
//                                                let key = "pet_avatar" + Date().secondStamp + PJUser.shared.userModel!.uid! + "\(c_i)"
                                                QNUploadManager()?.put(assets[c_i],
                                                                       key: nil,
                                                                       token: tokens[c_i].string,
                                                                       complete: { (info, key, respDict) in
                                                                        guard let `respDict` = respDict else { return }
                                                                        // key 即为文件名
                                                                        let key = respDict["key"]
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
}

// MARK: - URL
extension PJImageUploader {
    enum URL: String {
        case upload = "realPet/uploadToken"
    }
}
