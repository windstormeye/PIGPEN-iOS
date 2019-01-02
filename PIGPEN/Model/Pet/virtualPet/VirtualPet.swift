//
//  VirtualPet.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/13.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import Foundation

class PJVirtualPet {
    var model: VirtualPetModel?
    
    class func create(model: VirtualPetModel,
                      complateHandler: @escaping () -> Void,
                      failedHandler: @escaping (PJNetwork.Error) -> Void) {
        let parameters = [
            "pet_nick_name": model.nick_name!,
            "gender": String(model.gender!),
            "breed": String(model.breed!),
            "uid": PJUser.shared.userModel?.uid ?? "",
        ]
        PJNetwork.shared.requstWithPost(path: VirtualPetUrl.create.rawValue,
                                        parameters: parameters,
                                        complement: { (dataDic) in
                                            if dataDic["msgCode"]?.intValue == 0 {
                                                complateHandler()
                                            } else {
                                                let error = PJNetwork.Error(errorCode: dataDic["msgCode"]?.intValue,
                                                                            errorMsg: dataDic["msg"]?.string)
                                                failedHandler(error)
                                            }
        }) { (errorString) in
            failedHandler(PJNetwork.Error(errorCode: 0, errorMsg: "未知错误"))
        }
    }
}

extension PJVirtualPet {
    enum VirtualPetUrl: String {
        case create = "virtualPet/create"
    }
    
    struct VirtualPetModel: Codable {
        var pet_id: String?
        var nick_name: String?
        var gender: Int?
        var breed: Int?
    }
}
