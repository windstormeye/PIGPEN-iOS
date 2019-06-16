//
//  PJPet.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/5/7.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import Foundation

class PJPet {
    static let shared = PJPet()
    
    func breedList(petType: PetType,
                   complationHandler: @escaping ([PetBreedGroupModel]) -> Void,
                   failedHandler: @escaping (PJNetwork.Error) -> Void) {
        let parameters = [
            "pet_type": String(petType.rawValue)
        ]
        PJNetwork.shared.requstWithGet(path: Url.breeds.rawValue,
                                       parameters: parameters,
                                       complement: { (dataDic) in
                                        if dataDic["msgCode"]?.intValue == 0 {
                                            var models = [PetBreedGroupModel]()
                                            let dicts = dataDic["msg"]!["breeds"].arrayValue
                                            for dict in dicts {
                                                let model = dataConvertToModel(PetBreedGroupModel(),
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
    func createPet(model: Pet,
                   complateHandler: @escaping ((Pet) -> Void),
                   failureHandler: @escaping ((PJNetwork.Error) -> Void)) {
        let parameters = [
            "pet_nick_name": model.nick_name,
            "gender": model.gender,
            "pet_type": model.pet_type.rawValue,
            "birth_time": model.birth_time,
            "weight": model.weight,
            "ppp_status": model.ppp_status,
            "love_status": model.love_status,
            "relation_code": model.relationship,
            "avatar_key": model.avatar_url,
            "breed_type": model.breed_type,
            "food_weight": model.food_weight,
            "activity": model.activity
            ] as [String : Any]
        
        PJNetwork.shared.requstWithPost(path: Url.create.rawValue,
                                        parameters: parameters,
                                        complement: { (resDict) in
                                            if resDict["msgCode"]?.intValue == 0 {
                                                let petModel = dataConvertToModel(Pet(),
                                                                                  from: try! (resDict["msg"]?.rawData())!)
                                                complateHandler(petModel!)
                                            }
        }) { (errorString) in
            let error = PJNetwork.Error(errorCode: 0, errorMsg: errorString)
            failureHandler(error)
        }
    }
}

extension PJPet {
    enum Url: String {
        case create = "pet/"
        case breeds = "pet/breeds"
    }
}

extension PJPet {
    enum PetType: Int, Codable {
        case cat = 0
        case dog
    }
    
    struct Pet: Codable {
        /// 宠物标识符
        var pet_id: Int
        /// 宠物昵称
        var nick_name: String
        /// 宠物类型：0 = 猫，1 = 狗
        var pet_type: PetType
        /// 体重
        var weight: Int
        /// 绝育状态
        var ppp_status: Int
        /// 感情状态
        var love_status: Int
        /// 进食量
        var food_weight: Int
        /// 生日
        var birth_time: Int
        /// 性别
        var gender: Int
        /// 品种
        var breed_type: String
        /// 宠物活跃程度
        var activity: Int = 0
        /// 创建时间
        var created_time: Int
        /// 宠物头像
        var avatar_url: String
        /// 宠物关系
        var relationship: Int
        /// 宠物分数
        var score: PetScore
        
        init() {
            self.pet_id = -1
            self.nick_name = ""
            self.pet_type = .cat
            self.weight = -1
            self.ppp_status = -1
            self.love_status = -1
            self.birth_time = -1
            self.food_weight = -1
            // 默认是女生
            self.gender = 0
            self.breed_type = ""
            self.created_time = -1
            self.avatar_url = ""
            self.relationship = -1
            self.score = PetScore()
        }
    }
    
    struct PetBreedModel: Codable {
        var id: Int
        var zh_name: String
    }
    
    struct PetBreedGroupModel: Codable {
        var group: String
        var breeds: [PetBreedModel]
        
        init() {
            self.group = ""
            self.breeds = []
        }
    }
    
    struct PetScore: Codable {
        var food_s: Float
        var water_s: Float
        var play_s: Float
        var happy_s: Float
        
        init() {
            food_s = 0
            water_s = 0
            play_s = 0
            happy_s = 0
        }
    }
}
