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
    
    /// 宠物品种列表
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
        }) {
            failureHandler($0)
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
        }) {
            failedHandler($0)
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
        }) {
            failedHandler($0)
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
        }) {
            failedHandler($0)
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
        }) {
            failedHandler($0)
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
        }) {
            failedHandler($0)
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
        }) {
            failedHandler($0)
        }
    }
    
    /// 获取宠物今日喝水数据
    func petTodayDrink(pet: PJPet.Pet, complateHandler: @escaping ((PetDrink) -> Void), failedHandler: @escaping ((PJNetwork.Error) -> Void)) {
        let parameters = [
            "pet_id": String(pet.pet_id),
        ]
        
        PJNetwork.shared.requstWithGet(path: Url.petDrink.rawValue, parameters: parameters, complement: { (resDict) in
            if resDict["msgCode"]?.intValue == 0 {
                let viewModel = dataConvertToModel(PetDrink(), from: try! (resDict["msg"]?.rawData())!)
                complateHandler(viewModel!)
            }
        }) {
            failedHandler($0)
        }
    }
    
    /// 上传宠物喝水数据
    func petDrinkUpload(pet: PJPet.Pet, waters: Int, complateHandler: @escaping (() -> Void), failedHandler: @escaping ((PJNetwork.Error) -> Void)) {
        let parameters = [
            "pet_id": String(pet.pet_id),
            "waters": String(waters)
        ]
        
        PJNetwork.shared.requstWithPost(path: Url.uploadWater.rawValue, parameters: parameters, complement: { (resDict) in
            if resDict["msgCode"]?.intValue == 0 {
                complateHandler()
            }
        }) {
            failedHandler($0)
        }
    }
    
    /// 获取宠物历史喝水数据
    func petDrinkHistory(pet: PJPet.Pet, complateHandler: @escaping (([PetDrinkHistory]) -> Void), failedHandler: @escaping ((PJNetwork.Error) -> Void)) {
        let parameters = [
            "pet_id": String(pet.pet_id),
        ]
        
        PJNetwork.shared.requstWithGet(path: Url.petDrinkHistory.rawValue, parameters: parameters, complement: { (resDict) in
            if resDict["msgCode"]?.intValue == 0 {
                var viewModels = [PetDrinkHistory]()
                let drinkDicts = resDict["msg"]!.arrayValue

                for p in drinkDicts {
                    let drinkModel = dataConvertToModel(PetDrinkHistory(), from: try! p.rawData())
                    viewModels.append(drinkModel!)
                }
                complateHandler(viewModels)
            }
        }) {
            failedHandler($0)
        }
    }
    
    /// 获取宠物今日吃饭数据
    func petTodayEat(pet: PJPet.Pet, complateHandler: @escaping ((PetEat) -> Void), failedHandler: @escaping ((PJNetwork.Error) -> Void)) {
        let parameters = [
            "pet_id": String(pet.pet_id),
        ]
        
        PJNetwork.shared.requstWithGet(path: Url.petEat.rawValue, parameters: parameters, complement: { (resDict) in
            if resDict["msgCode"]?.intValue == 0 {
                let viewModel = dataConvertToModel(PetEat(), from: try! (resDict["msg"]?.rawData())!)
                complateHandler(viewModel!)
            }
        }) {
            failedHandler($0)
        }
    }
    
    /// 上传宠物喝水数据
    func petEatUpload(pet: PJPet.Pet, foods: Int, complateHandler: @escaping (() -> Void), failedHandler: @escaping ((PJNetwork.Error) -> Void)) {
        let parameters = [
            "pet_id": String(pet.pet_id),
            "foods": String(foods)
        ]
        
        PJNetwork.shared.requstWithPost(path: Url.uploadFood.rawValue, parameters: parameters, complement: { (resDict) in
            if resDict["msgCode"]?.intValue == 0 {
                complateHandler()
            }
        }) {
            failedHandler($0)
        }
    }
    
    /// 获取宠物历史喝水数据
    func petEatHistory(pet: PJPet.Pet, complateHandler: @escaping (([PetEatHistory]) -> Void), failedHandler: @escaping ((PJNetwork.Error) -> Void)) {
        let parameters = [
            "pet_id": String(pet.pet_id),
        ]
        
        PJNetwork.shared.requstWithGet(path: Url.petEatHistory.rawValue, parameters: parameters, complement: { (resDict) in
            if resDict["msgCode"]?.intValue == 0 {
                var viewModels = [PetEatHistory]()
                let eatDicts = resDict["msg"]!.arrayValue
                
                for p in eatDicts {
                    let drinkModel = dataConvertToModel(PetEatHistory(), from: try! p.rawData())
                    viewModels.append(drinkModel!)
                }
                complateHandler(viewModels)
            }
        }) {
            failedHandler($0)
        }
    }
    
    /// 删除宠物历史某个喝水记录
    func deletePetDrink(pet: PJPet.Pet, drinkId: Int,complateHandler: @escaping (() -> Void), failedHandler: @escaping ((PJNetwork.Error) -> Void)) {
        let parameters = [
            "pet_id": String(pet.pet_id),
            "drink_id": String(drinkId)
        ]
        
        PJNetwork.shared.requstWithPost(path: Url.deletePetDrink.rawValue, parameters: parameters, complement: { (resDict) in
            if resDict["msgCode"]?.intValue == 0 {
                complateHandler()
            }
        }) {
            failedHandler($0)
        }
    }
    
    /// 删除宠物历史某个吃饭记录
    func deletePetEat(pet: PJPet.Pet, eatId: Int,complateHandler: @escaping (() -> Void), failedHandler: @escaping ((PJNetwork.Error) -> Void)) {
        let parameters = [
            "pet_id": String(pet.pet_id),
            "eat_id": String(eatId)
        ]
        
        PJNetwork.shared.requstWithPost(path: Url.deletePetEat.rawValue, parameters: parameters, complement: { (resDict) in
            if resDict["msgCode"]?.intValue == 0 {
                complateHandler()
            }
        }) {
            failedHandler($0)
        }
    }
    
    /// 删除宠物历史某个「玩」记录
    func deletePetPlay(pet: PJPet.Pet, playId: Int,complateHandler: @escaping (() -> Void), failedHandler: @escaping ((PJNetwork.Error) -> Void)) {
        let parameters = [
            "pet_id": String(pet.pet_id),
            "play_id": String(playId),
            "pet_type": String(pet.pet_type.rawValue)
        ]
        
        PJNetwork.shared.requstWithPost(path: Url.deletePetPlay.rawValue, parameters: parameters, complement: { (resDict) in
            if resDict["msgCode"]?.intValue == 0 {
                complateHandler()
            }
        }) {
            failedHandler($0)
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
        /// 获取今日喝水看板数据
        case petDrink = "drink/day"
        /// 提交宠物喝水数据
        case uploadWater = "drink/create"
        /// 获取宠物历史喝水数据
        case petDrinkHistory = "drink/all"
        /// 获取今日吃饭看板数据
        case petEat = "eat/day"
        /// 提交宠物吃饭数据
        case uploadFood = "eat/create"
        /// 获取宠物历史吃饭数据
        case petEatHistory = "eat/all"
        /// 删除宠物喝水历史数据
        case deletePetDrink = "drink/delete"
        /// 删除宠物吃饭历史数据
        case deletePetEat = "eat/delete"
        /// 删除宠物「玩」历史数据
        case deletePetPlay = "play/delete"
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
        var relationship: Int? = -1
        
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
        struct Play: Codable {
            var id: Int
            var kcals: Int
            var durations: Int
            
            init() {
                id = 0
                kcals = 0
                durations = 0
            }
        }

        var plays: [Play]
        var date: Int
        
        init() {
            plays = [Play]()
            date = 0
        }
    }
    
    /// 喝水看板数据
    struct PetDrink: Codable {
        var times: Int
        var water_today: Int
        var water_target_today: Int
        var score: Float
        
        init() {
            times = 0
            water_today = 0
            water_target_today = 0
            score = 0
        }
    }
    
    /// 喝水历史数据
    struct PetDrinkHistory: Codable {
        struct Drink: Codable {
            var id: Int
            var waters: Int
            var created_time: Int
            
            init() {
                id = 0
                waters = 0
                created_time = 0
            }
        }
        
        var waters: [Drink]
        var date: Int
        
        init() {
            waters = [Drink]()
            date = 0
        }
    }
    
    /// 吃饭看板数据
    struct PetEat: Codable {
        var times: Int
        var foods_today: Int
        var food_target_today: Int
        var score: Float
        
        init() {
            times = 0
            foods_today = 0
            food_target_today = 0
            score = 0
        }
    }
    
    /// 吃饭历史数据
    struct PetEatHistory: Codable {
        struct Eat: Codable {
            var id: Int
            var foods: Int
            var created_time: Int
            
            init() {
                id = 0
                foods = 0
                created_time = 0
            }
        }
        
        var foods: [Eat]
        var date: Int
        
        init() {
            foods = [Eat]()
            date = 0
        }
    }
}
