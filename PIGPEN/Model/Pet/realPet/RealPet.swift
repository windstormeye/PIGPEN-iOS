//
//  Pet.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/8.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import Foundation

enum RealPetUrl: String {
    case breeds = "realPet/breeds"
}

struct RealPetModel: Codable {
    var user_name: String?
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

class RealPet {
    var model: RealPetModel?
    
    class func breedList(petType: String,
                         complationHandler: @escaping ([RealPetBreedGroupModel]) -> Void,
                         failedHandler: @escaping (PJError) -> Void) {
        let parameters = [
            "nick_name": PJUser.shared.nickName ?? "",
            "pet_type": petType
            ]
        PJNetwork.shared.requstWithGet(path: RealPetUrl.breeds.rawValue,
                                       parameters: parameters,
                                       complement: { (dataDic) in
                                        if dataDic["msgCode"]?.intValue == 666 {
                                            var models = [RealPetBreedGroupModel]()
                                            let dicts = dataDic["msg"]!["breeds"].arrayValue
                                            for dict in dicts {
                                                if let model = try? JSONDecoder().decode(RealPetBreedGroupModel.self, from: dict.rawData()) {
                                                    models.append(model)
                                                }
                                            }
                                            complationHandler(models)
                                        } else {
                                            let error = PJError(errorCode: dataDic["msgCode"]?.intValue, errorMsg: dataDic["msg"]?.string)
                                            failedHandler(error)
                                        }
        }) { (errorString) in
            failedHandler(PJError(errorCode: 0,
                                  errorMsg: "未知错误"))
        }
    }
}
