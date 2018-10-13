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


struct PJError {
    let errorCode: Int?
    let errorMsg: String?
}


class PJNetwork {
    static let shared = PJNetwork()
    
    let hostName = "http://127.0.0.1:8000/"
    
    
    func requstWithGet(path: String,
                       parameters: [String: String],
                       complement: @escaping ([String: JSON]) -> Void,
                       failed: @escaping (String) -> Void) {
        let parametes = parametersHandler(parameters: parameters)
        let headerParameters: HTTPHeaders = [
            "user_token": PJUser.shared.token ?? "",
            "timestamp": String.timestape()
        ]
        Alamofire.request(hostName + path,
                          method: .get,
                          parameters: parametes,
                          encoding: URLEncoding.default,
                          headers: headerParameters).responseJSON { (response) in
                            switch response.result {
                            case .success(_):
                                complement(self.handleSuccess(response.data))
                            case .failure(_):
                                failed(response.result.error?.localizedDescription ?? "发生错误")
                            }
        }
    }
    
    
    func requstWithPost(path: String,
                        parameters: [String: String],
                        complement: @escaping ([String: JSON]) -> Void,
                        failed: @escaping (String) -> Void) {
        let parametes = parametersHandler(parameters: parameters)
        let headerParameters: HTTPHeaders = [
            "usertoken": PJUser.shared.token ?? "",
            "timestamp": String.timestape()
        ]
        Alamofire.request(hostName + path,
                          method: .post,
                          parameters: parametes,
                          encoding: URLEncoding.default,
                          headers: headerParameters).responseJSON { (response) in
                            switch response.result {
                            case .success(_):
                                complement(self.handleSuccess(response.data))
                            case .failure(_):
                                failed(response.result.error?.localizedDescription ?? "发生错误")
                            }
        }
    }
    
    
    private func handleSuccess(_ data: Data?) -> [String: JSON] {
        if let data = data {
            if let jsonData = try? JSON(data: data).dictionary {
                return jsonData!
            }
        }
        return [:]
    }
    
    
    private func parametersHandler(parameters: [String: String]) -> Parameters {
        var pa = Parameters()
        for (k ,v) in parameters {
            pa[k] = v
        }
        return pa
    }
    
}
