//
//  Pet.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/8.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import Foundation

class PJRealPet {
    var model: RealPetModel?
    
    class func breedList(petType: String,
                         complationHandler: @escaping ([RealPetBreedGroupModel]) -> Void,
                         failedHandler: @escaping (PJNetwork.Error) -> Void) {
        let parameters = [
            "nick_name": PJUser.shared.userModel?.nick_name ?? "",
            "pet_type": petType
            ]
        PJNetwork.shared.requstWithGet(path: RealPetUrl.breeds.rawValue,
                                       parameters: parameters,
                                       complement: { (dataDic) in
                                        if dataDic["msgCode"]?.intValue == 666 {
                                            var models = [RealPetBreedGroupModel]()
                                            let dicts = dataDic["msg"]!["breeds"].arrayValue
                                            for dict in dicts {
                                                // TODO: JSONDecoder 改
                                                if let model = try? JSONDecoder().decode(RealPetBreedGroupModel.self,
                                                                                         from: dict.rawData()) {
                                                    models.append(model)
                                                }
                                            }
                                            complationHandler(models)
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

extension PJRealPet {
    enum RealPetUrl: String {
        case breeds = "realPet/breeds"
    }
    
    struct RealPetModel: Codable {
        var pet_id: String?
        var nick_name: String?
        var gender: Int?
        var pet_type: String?
        var weight: String?
        var ppp_status: Int?
        var love_status: Int?
        var family_relation: Int?
        var birth_time: String?
    }
    
    struct RealPetBreedModel: Codable {
        var id: Int?
        var zh_name: String?
    }
    
    struct RealPetBreedGroupModel: Codable {
        var group: String?
        var breeds: [RealPetBreedModel]?
    }
}
