//
//  VirtualPet.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/13.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import Foundation

enum VirtualPetUrl: String {
    case create = "virtualPet/create"
}

struct VirtualPetModel {
    var nick_name: String
    var gender: Int
    var breed: Int
}

class PJVirtualPet {
    var model: VirtualPetModel?
    
    class func create(model: VirtualPetModel,
                      complateHandler: @escaping () -> Void,
                      failedHandler: @escaping (PJError) -> Void) {
        let parameters = [
            "nick_name": model.nick_name,
            "gender": String(model.gender),
            "breed": String(model.breed),
            "user_nick_name": PJUser.shared.nickName ?? "",
        ]
        PJNetwork.shared.requstWithPost(path: VirtualPetUrl.create.rawValue,
                                        parameters: parameters,
                                        complement: { (dataDic) in
                                            if dataDic["msgCode"]?.intValue == 666 {
                                                complateHandler()
                                            } else {
                                                let error = PJError(errorCode: dataDic["msgCode"]?.intValue,
                                                                    errorMsg: dataDic["msg"]?.string)
                                                failedHandler(error)
                                            }
        }) { (errorString) in
            failedHandler(PJError(errorCode: 0,
                                  errorMsg: "未知错误"))
        }
    }
}
