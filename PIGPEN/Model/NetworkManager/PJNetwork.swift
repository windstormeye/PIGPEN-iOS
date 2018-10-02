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
    
    let hostName = "http://localhost:8000"
    
    
    func requstWithGet(parametes: [String: String],
                       complement: @escaping ([JSON]) -> Void,
                       failed: @escaping (String) -> Void) {
        
        var pa = Parameters()
        for (k ,v) in parametes {
            pa[k] = v
        }
        
        Alamofire.request(hostName,
                          method: .get,
                          parameters: pa,
                          encoding: URLEncoding.default,
                          headers: nil).responseJSON { (response) in
                            switch response.result {
                            case .success(_):
                                complement(self.handleSuccess(response.data))
                            case .failure(_):
                                failed(response.result.error?.localizedDescription ?? "发生错误")
                            }
        }
    }
    
    
    func requstWithPost(parametes: Parameters,
                       complement: @escaping ([JSON]) -> Void,
                       failed: @escaping (String) -> Void) {
        Alamofire.request(hostName,
                          method: .post,
                          parameters: parametes,
                          encoding: URLEncoding.default,
                          headers: nil).responseJSON { (response) in
                            switch response.result {
                            case .success(_):
                                complement(self.handleSuccess(response.data))
                            case .failure(_):
                                failed(response.result.error?.localizedDescription ?? "发生错误")
                            }
        }
    }
    
    
    private func handleSuccess(_ data: Data?) -> [JSON] {
        if let data = data {
            if let jsonData = try? JSON(data: data).array {
                return jsonData!
            }
        }
        return []
    }
    
}
