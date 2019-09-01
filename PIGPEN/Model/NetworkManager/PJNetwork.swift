//
//  PJNetwork.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/2.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PJNetwork {
    static let shared = PJNetwork()
    
//    let hostName = "http://127.0.0.1:8000/"
//    let hostName = "http://192.168.0.110:8000/"
    let hostName = "http://pigpen.pjhubs.com/"
    
    
    func requstWithGet(path: String,
                       parameters: [String: String],
                       complement: @escaping ([String: JSON]) -> Void,
                       failed: @escaping (Error) -> Void) {
        var parameters = parameters
        if parameters["nick_name"] == nil {
            parameters["nick_name"] = PJUser.shared.userModel.nick_name
        }
        if parameters["uid"] == nil {
            parameters["uid"] = String(PJUser.shared.userModel.uid)
        }
        
        let params = parametersHandler(parameters: parameters)
        let headerParameters: HTTPHeaders = [
            "usertoken": PJUser.shared.userModel.token ?? "",
            "timestamp": String.timestampe(),
        ]
        
        debugOnly {
            print(params)
        }
        
        Alamofire.request(hostName + path,
                          method: .get,
                          parameters: params,
                          encoding: URLEncoding.default,
                          headers: headerParameters).responseJSON { (response) in
                            switch response.result {
                            case .success(_):
                                complement(self.handleSuccess(response.data))
                            case .failure(_):
                                let errorString = response.result.error?.localizedDescription ?? "发生错误"
                                debugOnly {
                                    print(errorString)
                                }
                                failed(Error(errorCode: -1, errorMsg: errorString))
                            }
        }
    }
    
    
    func requstWithPost(path: String,
                        parameters: [String: Any],
                        complement: @escaping ([String: JSON]) -> Void,
                        failed: @escaping (Error) -> Void) {
        var parameters = parameters
        if parameters["nick_name"] == nil {
            parameters["nick_name"] = PJUser.shared.userModel.nick_name
        }
        if parameters["uid"] == nil {
            parameters["uid"] = PJUser.shared.userModel.uid
        }
        
        let params = parametersHandler(parameters: parameters)
        let headerParameters: HTTPHeaders = [
            "usertoken": PJUser.shared.userModel.token ?? "",
            "timestamp": String.timestampe(),
        ]
        
        debugOnly {
            print(params)
        }
        
        Alamofire.request(hostName + path,
                          method: .post,
                          parameters: params,
                          encoding: URLEncoding.default,
                          headers: headerParameters).responseJSON { (response) in
                            switch response.result {
                            case .success(_):
                                complement(self.handleSuccess(response.data))
                            case .failure(_):
                                let errorString = response.result.error?.localizedDescription ?? "发生错误"
                                debugOnly {
                                    print(errorString)
                                }
                                failed(Error(errorCode: -1, errorMsg: errorString))
                            }
        }
    }
    
    
    private func handleSuccess(_ data: Data?) -> [String: JSON] {
        if let data = data {
            if let jsonData = try? JSON(data: data).dictionary {
                handleNetworkError(dict: jsonData!)
                debugOnly {
                    print(jsonData!)
                }
                return jsonData!
            }
        }
        return [:]
    }
    
    
    private func parametersHandler(parameters: [String: Any]) -> Parameters {
        var pa = Parameters()
        for (k ,v) in parameters {
            pa[k] = v
        }
        return pa
    }
    
    private func handleNetworkError(dict: [String: JSON]) {
        switch dict["msgCode"] {
        case 2333: break
        case 1001:
            if !PJUser.shared.isLogin {
                NotificationCenter.default.post(name: .gotoLogin(), object: nil)
                PJUser.shared.isLogin = !PJUser.shared.isLogin
            }
        case 1002: break
        case 2001: break
        default: break
        }
    }
    
}

extension PJNetwork {
    struct Error {
        let errorCode: Int
        let errorMsg: String
    }
    
    
    enum NetworkError {
        case token
        case timeout
        case parameters
        case methon
    }

}
