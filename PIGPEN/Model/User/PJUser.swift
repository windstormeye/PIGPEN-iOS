//
//  PJUser.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/29.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import Foundation
import CryptoSwift


class PJUser {
    // MARK: - Public Properties
    static let shared = PJUser()
    var userModel: UserModel?
    var isLoginTXIM: Bool = false
    
    // MARK: - Private Methods
    private let userAccountPath =  NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                       FileManager.SearchPathDomainMask.userDomainMask, true).first!
    
    // MARK: - Life Cycle
    init() {
        userModel = self.readBySandBox()
        if userModel == nil {
            userModel = UserModel(nick_name: "",
                                  gender: 0,
                                  avatar: -1,
                                  feeding_status: [0, 0, 0],
                                  level: -1,
                                  follow: 0,
                                  star: 0,
                                  token: "",
                                  uid: "",
                                  money: 0,
                                  rcToken: "")
        }
    }
    
    // MARK: - Permanent Data
    private func saveToSandBox() {
        let encoder = JSONEncoder()
        if let BeerData = try? encoder.encode(self.userModel) {
            let url = URL.init(fileURLWithPath: userAccountPath).appendingPathComponent("userData.data")
            do {
                try BeerData.write(to: url)
                print("完成了对数据的二进制化归档")
            } catch {
                assert(true, "saveToSandBox \(error.localizedDescription)")
            }
        }
    }
    
    
    private func readBySandBox() -> UserModel? {
        let url = URL.init(fileURLWithPath: userAccountPath).appendingPathComponent("userData.data")
        do {
            let data = try FileHandle.init(forReadingFrom: url)
            do {
                return try JSONDecoder().decode(UserModel.self, from: data.readDataToEndOfFile())
            } catch {
                assert(true, "readBySandBox JSONDecoder \(error.localizedDescription)")
            }
        } catch {
            assert(true, "readBySandBox \(error.localizedDescription)")
        }
        return nil
    }
}

// MARK: - URL Implementation
extension PJUser {
    func details(details_uid: String,
                 getSelf: Bool,
                 completeHandler: @escaping (UserModel) -> Void,
                 failedHandler: @escaping (PJNetwork.Error) -> Void) {
        PJNetwork.shared.requstWithGet(path: UserUrl.details.rawValue,
                                       parameters: ["details_uid": details_uid],
                                       complement: { (dataDic) in
                                        if dataDic["msgCode"]?.intValue == 0 {
                                            var dataDic = dataDic["msg"]!
                                            let userDic = dataDic["masuser"].dictionary!
                                            let gender = userDic["gender"]?.intValue
                                            let nickName = userDic["nick_name"]?.string
                                            let avatar = userDic["avatar"]?.intValue
                                            let uid = userDic["uid"]?.string
                                            let money = userDic["money"]?.int
                                                
                                            let f_s = dataDic["feeding_status"].array
                                            var feedingStatus = [Int]()
                                            for s in f_s! {
                                                feedingStatus.append(s.int!)
                                            }
                                            
                                            let user = UserModel(nick_name: nickName,
                                                                 gender: gender,
                                                                 avatar: avatar,
                                                                 feeding_status: feedingStatus,
                                                                 level: -1,
                                                                 follow: 0,
                                                                 star: 0,
                                                                 token: nil,
                                                                 uid: uid,
                                                                 money: money,
                                                                 rcToken: "")
                                            if getSelf {
                                                self.userModel = user
                                                self.saveToSandBox()
                                            }
                                            
                                            completeHandler(user)
                                        } else {
                                            let error = PJNetwork.Error(errorCode: dataDic["msgCode"]?.intValue,
                                                                        errorMsg: dataDic["msg"]?.string)
                                            failedHandler(error)
                                        }
        }) { (errorString) in
            failedHandler(PJNetwork.Error(errorCode: -1, errorMsg: "未知错误"))
        }
    }
    
    
    func update(avatar: Int,
                gender: Int,
                completeHandler: @escaping () -> Void,
                failedHandler: @escaping (PJNetwork.Error) -> Void) {
        let parameters = [
            "avatar": String(avatar),
            "gender": String(gender),
            ]
        PJNetwork.shared.requstWithPost(path: UserUrl.update.rawValue,
                                        parameters: parameters,
                                        complement: { (dataDic) in
                                            if dataDic["msgCode"]?.intValue == 0 {
                                                self.logout()
                                                
                                                var dataDic = dataDic["msg"]!
                                                let userDic = dataDic["masuser"].dictionary!
                                                self.userModel?.gender = userDic["gender"]?.intValue ?? 0
                                                self.userModel?.avatar = userDic["avatar"]?.intValue ?? -1
                                                
                                                self.saveToSandBox()
                                                completeHandler()
                                            } else {
                                                let error = PJNetwork.Error(errorCode: dataDic["msgCode"]?.intValue,
                                                                            errorMsg: dataDic["msg"]?.string)
                                                failedHandler(error)
                                            }
        }) { (errorString) in
            failedHandler(PJNetwork.Error(errorCode: -1, errorMsg: "未知错误"))
        }
    }
    
    
    func register(registerModel: UserRegisterModel,
                  completeHandler: @escaping () -> Void,
                  failedHandler: @escaping (PJNetwork.Error) -> Void) {
        let salt = String(registerModel.phone.reversed())
        var psd = registerModel.passwd + salt
        psd = psd.md5()
        
        let parameters = [
            "phoneNumber": registerModel.phone,
            "password": psd,
            "avatar": String(registerModel.avatar),
            "gender": String(registerModel.gender),
            "nick_name": registerModel.nickName,
            ]
        PJNetwork.shared.requstWithPost(path: UserUrl.register.rawValue,
                                        parameters: parameters,
                                        complement: { (dataDic) in
                                            if dataDic["msgCode"]?.intValue == 0 {
                                                self.logout()
                                                
                                                var dataDic = dataDic["msg"]!
                                                let userDic = dataDic["masuser"].dictionary!
                                                self.userModel?.nick_name = userDic["nick_name"]?.string ?? ""
                                                self.userModel?.gender = userDic["gender"]?.intValue ?? 0
                                                self.userModel?.avatar = userDic["avatar"]?.intValue ?? -1
                                                self.userModel?.token = dataDic["token"].string!
                                                self.userModel?.uid = dataDic["uid"].string
                                                self.userModel?.level = dataDic["level"].float
                                                self.userModel?.follow = dataDic["follow"].int
                                                self.userModel?.star = dataDic["star"].int
                                                
                                                let f_s = dataDic["feeding_status"].array
                                                var feedingStatus = [Int]()
                                                for s in f_s! {
                                                    feedingStatus.append(s.int!)
                                                }
                                                self.userModel?.feeding_status = feedingStatus
                                                
                                                self.saveToSandBox()
                                                completeHandler()
                                            } else {
                                                let error = PJNetwork.Error(errorCode: dataDic["msgCode"]?.intValue,
                                                                            errorMsg: dataDic["msg"]?.string)
                                                failedHandler(error)
                                            }
        }) { (errorString) in
            failedHandler(PJNetwork.Error(errorCode: -1, errorMsg: "未知错误"))
        }
    }
    
    
    func login(phone: String,
               passwd: String,
               completeHandler: @escaping () -> Void,
               failedHandler: @escaping (PJNetwork.Error) -> Void) {
        let salt = String(phone.reversed())
        var psd = passwd + salt
        psd = psd.md5()
        var sign = psd + String.timestampe()
        sign = sign.md5()
        
        let parameters = [
            "phoneNumber": phone,
            "sign": sign,
            // 因为登录接口要做 md5 验证，所以 body 要带上
            "timestamp": String.timestampe(),
            ]
        PJNetwork.shared.requstWithPost(path: UserUrl.logIn.rawValue,
                                        parameters: parameters,
                                        complement: { (dataDic) in
                                            if dataDic["msgCode"]?.intValue == 0 {
                                                self.logout()
                                                
                                                var dataDic = dataDic["msg"]!
                                                let userDic = dataDic["masuser"].dictionary!
                                                self.userModel?.nick_name = userDic["nick_name"]?.string ?? ""
                                                self.userModel?.gender = userDic["gender"]?.intValue ?? 0
                                                self.userModel?.avatar = userDic["avatar"]?.intValue ?? -1
                                                self.userModel?.token = dataDic["token"].string!
                                                self.userModel?.uid = userDic["uid"]?.string!
                                                self.userModel?.level = userDic["level"]?.float ?? -1
                                                self.userModel?.follow = userDic["follow"]?.int ?? 0
                                                self.userModel?.star = userDic["star"]?.int ?? 0
                                                
                                                let f_s = dataDic["feeding_status"].array
                                                var feedingStatus = [Int]()
                                                for s in f_s! {
                                                    feedingStatus.append(s.int!)
                                                }
                                                
                                                self.userModel?.feeding_status = feedingStatus
                                                
                                                // 登录成功后获取融云token，并持久化
                                                self.rcToken(complateHandler: { (rcToken) in
                                                    self.userModel?.rcToken = rcToken
                                                    self.saveToSandBox()
                                                    completeHandler()
                                                }, failedHandler: { (error) in
                                                    failedHandler(error)
                                                })
                                            } else {
                                                let error = PJNetwork.Error(errorCode: dataDic["msgCode"]?.intValue,errorMsg: dataDic["msg"]?.string)
                                                failedHandler(error)
                                            }
        }, failed: { (errorString) in
            failedHandler(PJNetwork.Error(errorCode: -1, errorMsg: "未知错误"))
        })
    }
    
    func checkPhone(phoneString: String,
                    completeHandler: @escaping () -> Void,
                    failedHandler: @escaping (PJNetwork.Error) -> Void) {
        let parameters = [
            "phoneNumber": phoneString,
            ]
        
        PJNetwork.shared.requstWithGet(path: UserUrl.checkPhone.rawValue,
                                       parameters: parameters,
                                       complement: { (dataDic) in
                                        if dataDic["msgCode"]?.intValue == 0 {
                                            completeHandler()
                                        } else {
                                            let error = PJNetwork.Error(errorCode: dataDic["msgCode"]?.intValue,
                                                                        errorMsg: dataDic["msg"]?.string)
                                            failedHandler(error)
                                        }
        }, failed: { (errorString) in
            failedHandler(PJNetwork.Error(errorCode: -1, errorMsg: "未知错误"))
        })
    }
    
    func logout() {
        self.userModel = UserModel()
        // 可能在多个 page 下进行登出，然后再登录时账户信息错误
        saveToSandBox()
    }
    
    func pets(complateHandler: @escaping ([PJRealPet.RealPetModel], [PJVirtualPet.VirtualPetModel]) -> Void,
              failedHandler: @escaping (PJNetwork.Error) -> Void) {
        PJNetwork.shared.requstWithGet(path: UserUrl.pets.rawValue,
                                       parameters: [:],
                                       complement: { (dataDict) in
                                        if dataDict["msgCode"]?.intValue == 0 {
                                            let realPetDicts = dataDict["msg"]!["real_pet"].arrayValue
                                            let virtualPetDicts = dataDict["msg"]!["virtual_pet"].arrayValue
                                            
                                            var realPetModels = [PJRealPet.RealPetModel]()
                                            var virtualPetModels = [PJVirtualPet.VirtualPetModel]()
                                            
                                            for dict in realPetDicts {
                                                // TODO: JSONDecoder 改
                                                let model = dataConvertToModel(PJRealPet.RealPetModel(), from: try! dict.rawData())
                                                realPetModels.append(model!)
                                            }
                                            
                                            for dict in virtualPetDicts {
                                                // TODO: JSONDecoder 改
                                                if let model = try? JSONDecoder().decode(PJVirtualPet.VirtualPetModel.self,
                                                                                         from: dict.rawData()) {
                                                    virtualPetModels.append(model)
                                                }
                                            }
                                            
                                            complateHandler(realPetModels, virtualPetModels)
                                        } else {
                                            let error = PJNetwork.Error(errorCode: dataDict["msgCode"]?.intValue,
                                                                        errorMsg: dataDict["msg"]?.string)
                                            failedHandler(error)
                                        }
        }) { (errorString) in
            failedHandler(PJNetwork.Error(errorCode: -1, errorMsg: errorString))
        }
    }
    
    func rcToken(complateHandler: @escaping (String) -> Void,
                 failedHandler: @escaping (PJNetwork.Error) -> Void) {
        PJNetwork.shared.requstWithGet(path: UserUrl.rcToken.rawValue,
                                       parameters: [:], complement: { (dataDict) in
                                        if dataDict["msgCode"]?.intValue == 0 {
                                            let res = dataDict["msg"]?.dictionary
                                            complateHandler(res!["token"]!.string!)
                                        } else {
                                            let error = PJNetwork.Error(errorCode: dataDict["msgCode"]?.intValue,errorMsg: dataDict["msg"]?.string)
                                            failedHandler(error)
                                        }
        }) { (errorString) in
            failedHandler(PJNetwork.Error(errorCode: -1, errorMsg: errorString))
        }
    }
}

private extension PJUser {
    enum UserUrl: String {
        /// 注册
        case register = "masuser/createmasuser"
        /// 登录
        case logIn = "masuser/login"
        /// 退出登录
        case logOut = "masuser/logout"
        /// 更新用户信息
        case update = "masuser/update"
        /// 更新用户 token
        case updateToken = "masuser/updateToken"
        /// 获取某个用户简单信息
        case details = "masuser/getUserDetails"
        /// 检查用户手机号是否注册过
        case checkPhone = "masuser/checkPhone"
        /// 获取用户所有宠物信息
        case pets = "masuser/pets"
        /// 获取融云 token
        case rcToken = "masuser/getRCToken"
    }
}

extension PJUser {
    struct UserModel: Codable {
        /// 昵称
        var nick_name: String?
        /// 性别
        var gender: Int?
        /// 头像索引
        var avatar: Int?
        /// 饲养状态
        var feeding_status: [Int]?
        /// 评分
        var level: Float?
        /// 关注
        var follow: Int?
        /// 收藏
        var star: Int?
        /// 校验 token
        var token: String?
        /// 用户唯一标识符
        var uid: String?
        /// 猪饲料
        var money: Int?
        /// 融云IM token
        var rcToken: String?
    }
    
    // 用户注册时的中转 model
    struct UserRegisterModel {
        var nickName: String
        var phone: String
        var passwd: String
        var gender: Int
        var avatar: Int
    }
}
