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
                                        if dataDic["msgCode"]?.intValue == 0 {
                                            var models = [RealPetBreedGroupModel]()
                                            let dicts = dataDic["msg"]!["breeds"].arrayValue
                                            for dict in dicts {
                                                let model = dataConvertToModel(RealPetBreedGroupModel(), from: dict)
                                                if model != nil {
                                                    models.append(model!)
                                                }
//                                                if let model = try? JSONDecoder().decode(RealPetBreedGroupModel.self,
//                                                                                         from: dict.rawData()) {
//                                                    models.append(model)
//                                                }
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
    
    /// 创建新宠物
    class func createPet(model: RealPetRegisterModel,
                         complateHandler: @escaping ((RealPetModel) -> Void),
                         failureHandler: @escaping ((PJNetwork.Error) -> Void)) {
        // 想想看能不能直接模型转字典，不能
//        let parameters = []
    }
}

extension PJRealPet {
    enum RealPetUrl: String {
        case breeds = "realPet/breeds"
        case create = "realPet/createPet"
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
        var avatar_url: String?
    }
    
    struct RealPetRegisterModel: Codable {
        var pet_nick_name: String?
        var gender: Int?
        var pet_type: String?
        var weight: String?
        var ppp_status: String?
        var love_status: String?
        var family_relation: String?
        var birth_time: String?
        var avatar_key: String?
        var relation_code: String?
        var breed_type: String?
        var food_weight: String?
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
