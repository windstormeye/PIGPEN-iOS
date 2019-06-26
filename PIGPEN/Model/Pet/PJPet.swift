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
                                                let petModel = dataConvertToModel(Pet(), from: try! (resDict["msg"]?.rawData())!)
                                                complateHandler(petModel!)
                                            }
        }) { (errorString) in
            let error = PJNetwork.Error(errorCode: 0, errorMsg: errorString)
            failureHandler(error)
        }
    }
    
    /// 获取娱乐圈首页数据
    func getPlayData(complateHandler: @escaping (([PJPlayCellView.ViewModel]) -> Void),
                     failedHandler: @escaping ((PJNetwork.Error) -> Void)) {
        PJNetwork.shared.requstWithGet(path: Url.playDetails.rawValue,
                                       parameters: [:],
                                       complement: { (resDict) in
                                        var viewModels = [PJPlayCellView.ViewModel]()

                                        if resDict["msgCode"]?.intValue == 0 {
                                            let petDicts = resDict["msg"]!["pets"].arrayValue
                                            
                                            for p in petDicts {
                                                let petModel = dataConvertToModel(PJPet.Pet(), from: try! p["pet"].rawData())
                                                let scoreModel = dataConvertToModel(PJPet.PetScore(), from: try! p["score"].rawData())
                                                
                                                var model = PJPlayCellView.ViewModel()
                                                model.pet = petModel!
                                                model.score = scoreModel!
                                                
                                                viewModels.append(model)
                                            }
                                            
                                            complateHandler(viewModels)
                                        }
        }) { (errorString) in
            let error = PJNetwork.Error(errorCode: 0, errorMsg: errorString)
            failedHandler(error)
        }
    }
    
    /// 获取撸猫详情
    func getCatPlayDetails(pet: Pet,
                           complateHandler: @escaping ((CatPlay) -> Void),
                           failedHandler: @escaping ((PJNetwork.Error) -> Void)) {
        let parameters = [
            "pet_type": String(pet.pet_type.rawValue),
            "pet_id": String(pet.pet_id)
        ]
        
        PJNetwork.shared.requstWithGet(path: Url.catPlay.rawValue,
                                        parameters: parameters,
                                        complement: { (resDict) in
                                            if resDict["msgCode"]?.intValue == 0 {
                                                let catPlayModel = dataConvertToModel(CatPlay(), from: try! (resDict["msg"]?.rawData())!)
                                                complateHandler(catPlayModel!)
                                            }
        }) { (errorString) in
            let error = PJNetwork.Error(errorCode: 0, errorMsg: errorString)
            failedHandler(error)
        }
    }
    
    /// 上传撸猫数据
    func catPlayUpload(durations: Int,
                       pet: PJPet.Pet,
                       complateHandler: @escaping (() -> Void),
                       failedHandler: @escaping ((PJNetwork.Error) -> Void)) {
        
        let parameters = [
            "durations": durations,
            "pet_id": pet.pet_id,
            "pet_type": 0
        ]
        
        PJNetwork.shared.requstWithPost(path: Url.catPlayUpload.rawValue,
                                        parameters: parameters,
                                        complement: { (resDict) in
                                            if resDict["msgCode"]?.intValue == 0 {
                                                complateHandler()
                                            }
        }) { (errorString) in
            let error = PJNetwork.Error(errorCode: 0, errorMsg: errorString)
            failedHandler(error)
        }
    }
    
    /// 获取遛狗看板数据
    func getDogPlayDetails(pet: PJPet.Pet,
                           complateHandler: @escaping ((DogPlay) -> Void),
                           failedHandler: @escaping ((PJNetwork.Error) -> Void)) {
        let parameters = [
            "pet_id": String(pet.pet_id),
        ]
        
        PJNetwork.shared.requstWithGet(path: Url.dogPlay.rawValue,
                                       parameters: parameters,
                                       complement: { (resDict) in
                                        if resDict["msgCode"]?.intValue == 0 {
                                            let catPlayModel = dataConvertToModel(DogPlay(), from: try! (resDict["msg"]?.rawData())!)
                                            complateHandler(catPlayModel!)
                                        }
        }) { (errorString) in
            let error = PJNetwork.Error(errorCode: 0, errorMsg: errorString)
            failedHandler(error)
        }
    }
    
    /// 上传遛狗数据
    func dogPlaUpload(pet: PJPet.Pet,
                      distance: Int,
                      durations: Int,
                      complateHandler: @escaping (() -> Void),
                      failedHandler: @escaping ((PJNetwork.Error) -> Void)) {
        let parameters = [
            "kcal": String(Int(distanceToKcal(distance: CGFloat(distance)))),
            "pet_id": String(pet.pet_id),
            "pet_type": String(1),
            "durations": String(durations)
        ]
        
        PJNetwork.shared.requstWithPost(path: Url.dogPlayUpload.rawValue,
                                        parameters: parameters,
                                        complement: { (resDict) in
                                            if resDict["msgCode"]?.intValue == 0 {
                                                complateHandler()
                                            }
        }) { (errorString) in
            let error = PJNetwork.Error(errorCode: 0, errorMsg: errorString)
            failedHandler(error)
        }
    }
    
    /// 获取遛狗历史数据
    func dogPlayHistory(pet: PJPet.Pet, page: Int,complateHandler: @escaping (([DogPlayHistory]) -> Void), failedHandler: @escaping ((PJNetwork.Error) -> Void)) {
        let parameters = [
            "pet_id": String(pet.pet_id),
            "page": String(page)
        ]
        
        PJNetwork.shared.requstWithGet(path: Url.dogPlayHistory.rawValue, parameters: parameters, complement: { (resDict) in
            if resDict["msgCode"]?.intValue == 0 {
                let petDicts = resDict["msg"]!.arrayValue
                var viewModels = [DogPlayHistory]()
                
                for p in petDicts {
                    let dogPlayModel = dataConvertToModel(DogPlayHistory(), from: try! p.rawData())
                    viewModels.append(dogPlayModel!)
                }
                
                complateHandler(viewModels)
            }
        }) { (errorString) in
            let error = PJNetwork.Error(errorCode: 0, errorMsg: errorString)
            failedHandler(error)
        }
    }
}

extension PJPet {
    enum Url: String {
        /// 创建宠物
        case create = "pet/"
        /// 获取宠物品种
        case breeds = "pet/breeds"
        /// 获取娱乐圈宠物看板数据
        case playDetails = "pet/playDetails"
        /// 获取撸猫看板数据
        case catPlay = "play/cat"
        /// 上传撸猫数据
        case catPlayUpload = "play/updateCat"
        /// 上传遛狗数据
        case dogPlayUpload = "play/updateDog"
        /// 获取今日遛狗看板数据
        case dogPlay = "play/dogTodayPlay"
        /// 获取历史遛狗数据
        case dogPlayHistory = "play/dog"
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
        }
    }
    
    /// 宠物品种模型
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
    
    /// 娱乐圈宠物分数看板
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

    /// 撸猫看板
    struct CatPlay: Codable {
        var times: Int
        var duration_today: Int
        var created_time: Int
        var update_time: Int
        
        init() {
            times = 0
            duration_today = 0
            created_time = 0
            update_time = 0
        }
    }
    
    /// 遛狗看板数据
    struct DogPlay: Codable {
        // 遛狗次数
        var times: Int
        // 当天遛狗消耗卡路里
        var kcal_today: Int
        // 每日卡路里目标
        var kcal_target_today: Int
        
        init() {
            times = 0
            kcal_today = 0
            kcal_target_today = 0
        }
    }
    
    /// 遛狗历史数据
    struct DogPlayHistory: Codable {
        var kcals: Int
        var durations: Int

        init() {
            kcals = 0
            durations = 0
        }
    }
}
