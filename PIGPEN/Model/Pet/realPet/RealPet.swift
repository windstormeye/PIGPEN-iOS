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
            "pet_type": petType
        ]
        PJNetwork.shared.requstWithGet(path: RealPetUrl.breeds.rawValue,
                                       parameters: parameters,
                                       complement: { (dataDic) in
                                        if dataDic["msgCode"]?.intValue == 0 {
                                            var models = [RealPetBreedGroupModel]()
                                            let dicts = dataDic["msg"]!["breeds"].arrayValue
                                            for dict in dicts {
                                                let model = dataConvertToModel(RealPetBreedGroupModel(),
                                                                               from: try! dict.rawData())
                                                if model != nil {
                                                    models.append(model!)
                                                }
                                            }
                                            complationHandler(models)
                                        } else {
                                            let error = PJNetwork.Error(errorCode: dataDic["msgCode"]?.intValue ?? 0, errorMsg: dataDic["msg"]?.string ?? "未知错误")
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
        let parameters = [
            "pet_nick_name": model.pet_nick_name!,
            "gender": model.gender!,
            "pet_type": model.pet_type!,
            "birth_time": model.birth_time!,
            "weight": model.weight!,
            "ppp_status": model.ppp_status!,
            "love_status": model.love_status!,
            "relation_code": model.relation_code!,
            "avatar_key": model.avatar_key!,
            "breed_type": model.breed_type!,
            "food_weight": model.food_weight!
            ] as [String : Any]
        
        PJNetwork.shared.requstWithPost(path: RealPetUrl.create.rawValue,
                                        parameters: parameters,
                                        complement: { (resDict) in
                                            if resDict["msgCode"]?.intValue == 0 {
                                                let petModel = dataConvertToModel(RealPetModel(),
                                                                                  from: try! (resDict["msg"]?.rawData())!)
                                                complateHandler(petModel!)
                                            }
        }) { (errorString) in
            let error = PJNetwork.Error(errorCode: 0, errorMsg: errorString)
            failureHandler(error)
        }
    }
}

extension PJRealPet {
    enum RealPetUrl: String {
        case breeds = "realPet/breeds"
        case create = "realPet/createPet"
    }
    
    struct RealPetModel: Codable {
        var gender: Int?
        var weight: Int?
        var ppp_status: Int?
        var love_status: Int?
        var relationship: Int?
        var pet_id: String?
        var pet_type: String?
        var nick_name: String?
        var birth_time: String?
        var avatar_url: String?
        var breed_type: String?
        var created_time: String?
    }
    
    struct RealPetRegisterModel: Codable {
        var pet_nick_name: String?
        var gender: Int?
        var pet_type: String?
        var weight: Int?
        var ppp_status: Int?
        var love_status: Int?
        var birth_time: String?
        var avatar_key: String?
        var relation_code: Int?
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
