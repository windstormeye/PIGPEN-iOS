//
//  PJUserService.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/26.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import Foundation

// MARK: - Permanent Data
extension PJUser {
    func saveToSandBox() {
        let encoder = JSONEncoder()
        if let BeerData = try? encoder.encode(self.userModel) {
            let url = URL.init(fileURLWithPath: PJUser.userAccountPath).appendingPathComponent("userData.data")
            do {
                try BeerData.write(to: url)
                print("完成了对数据的二进制化归档")
            } catch {
                print("saveToSandBox \(error.localizedDescription)")
                assert(true, "saveToSandBox \(error.localizedDescription)")
            }
        }
    }
    
    
    func readBySandBox() -> UserModel? {
        let url = URL.init(fileURLWithPath: PJUser.userAccountPath).appendingPathComponent("userData.data")
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
    func details(details_uid: String, getSelf: Bool, completeHandler: @escaping (UserModel) -> Void, failedHandler: @escaping (PJNetwork.Error) -> Void) {
        PJNetwork.shared.requstWithGet(path: UserUrl.details.rawValue, parameters: ["details_uid": details_uid], complement: { (dataDic) in
            if dataDic["msgCode"]?.intValue == 0 {
                var dataDic = dataDic["msg"]!
                let userDic = dataDic["masuser"].dictionaryValue
                let gender = userDic["gender"]!.intValue
                let nickName = userDic["nick_name"]!.stringValue
                let avatar = userDic["avatar"]!.intValue
                let uid = userDic["uid"]!.intValue
                
                var user = UserModel(nick_name: nickName,
                                     gender: gender,
                                     avatar: avatar,
                                     token: nil,
                                     uid: uid,
                                     rcToken: nil)
                if getSelf {
                    user.token = self.userModel.token
                    user.rcToken = self.userModel.rcToken
                    self.userModel = user
                    self.saveToSandBox()
                }
                
                completeHandler(user)
            } else {
                let error = PJNetwork.Error(errorCode: dataDic["msgCode"]?.intValue ?? 0,
                                            errorMsg: dataDic["msg"]?.string ?? "未知错误")
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
                                                self.userModel.gender = userDic["gender"]?.intValue ?? 0
                                                self.userModel.avatar = userDic["avatar"]?.intValue ?? -1
                                                
                                                self.saveToSandBox()
                                                completeHandler()
                                            } else {
                                                let error = PJNetwork.Error(errorCode: dataDic["msgCode"]?.intValue ?? 0, errorMsg: dataDic["msg"]?.string ?? "未知错误")
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
                                                self.userModel.nick_name = userDic["nick_name"]?.string ?? ""
                                                self.userModel.gender = userDic["gender"]!.intValue
                                                self.userModel.avatar = userDic["avatar"]!.intValue
                                                self.userModel.token = dataDic["token"].string!
                                                self.userModel.uid = userDic["uid"]!.intValue
                                                
                                                Bugly.setUserIdentifier(String(self.userModel.uid))
                                                
                                                // 登录成功后获取融云token，并持久化
                                                self.rcToken(uid: String(self.userModel.uid), complateHandler: {
                                                    self.userModel.rcToken = $0
                                                    self.saveToSandBox()
                                                    
                                                    self.connectRC(completeHandler: { _ in completeHandler() }, failedHandler: { failedHandler($0) })}, failedHandler: { failedHandler($0) })
                                            } else {
                                                let error = PJNetwork.Error(errorCode: dataDic["msgCode"]?.intValue ?? 0, errorMsg: dataDic["msg"]?.string ?? "未知错误")
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
        PJNetwork.shared.requstWithPost(path: UserUrl.logIn.rawValue, parameters: parameters, complement: { (dataDic) in
            if dataDic["msgCode"]?.intValue == 0 {
                self.logout()
                var dataDic = dataDic["msg"]!
                let userDic = dataDic["masuser"].dictionaryValue
                self.userModel.nick_name = userDic["nick_name"]!.stringValue
                self.userModel.gender = userDic["gender"]!.intValue
                self.userModel.avatar = userDic["avatar"]!.intValue
                self.userModel.token = dataDic["token"].string!
                self.userModel.uid = userDic["uid"]!.intValue
                
                Bugly.setUserIdentifier(String(self.userModel.uid))
                
                // 登录成功后获取融云token，并持久化
                self.rcToken(uid: String(self.userModel.uid), complateHandler: {
                    self.userModel.rcToken = $0
                    self.saveToSandBox()
                    
                    self.connectRC(completeHandler: {_ in
                        completeHandler()
                    }, failedHandler: {
                        failedHandler($0)
                    })
                }, failedHandler: {
                    failedHandler($0)
                })
            } else {
                let error = PJNetwork.Error(errorCode: dataDic["msgCode"]?.intValue ?? 0,errorMsg: dataDic["msg"]?.string ?? "未知错误")
                failedHandler(error)
            }
        }, failed: {
            failedHandler(PJNetwork.Error(errorCode: -1, errorMsg: $0))
        })
    }
    
    /// 检测手机号是否存在
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
                                            let error = PJNetwork.Error(errorCode: dataDic["msgCode"]?.intValue ?? 0, errorMsg: dataDic["msg"]?.string ?? "未知错误")
                                            failedHandler(error)
                                        }
        }, failed: { (errorString) in
            failedHandler(PJNetwork.Error(errorCode: -1, errorMsg: "未知错误"))
        })
    }
    
    func logout() {
        self.userModel = UserModel()
        // 可能在多个 page 下进行登出，然后再登录时账户信息错误
        RCIMClient.shared()?.logout()
        saveToSandBox()
    }
    
    func pets(complateHandler: @escaping ([PJPet.Pet]) -> Void,
              failedHandler: @escaping (PJNetwork.Error) -> Void) {
        PJNetwork.shared.requstWithGet(path: UserUrl.pets.rawValue, parameters: [:], complement: { (dataDict) in
            if dataDict["msgCode"]?.intValue == 0 {
                let petDicts = dataDict["msg"]!["pets"].arrayValue
                
                var petModels = [PJPet.Pet]()
                
                for dict in petDicts {
                    let model = dataConvertToModel(PJPet.Pet(), from: try! dict.rawData())
                    petModels.append(model!)
                }
                
                self.pets = petModels
                
                complateHandler(petModels)
            } else {
                let error = PJNetwork.Error(errorCode: dataDict["msgCode"]?.intValue ?? 0, errorMsg: dataDict["msg"]?.string ?? "未知错误")
                failedHandler(error)
            }
        }) { (errorString) in
            failedHandler(PJNetwork.Error(errorCode: -1, errorMsg: errorString))
        }
    }
    
    func rcToken(uid: String,
                 complateHandler: @escaping (String) -> Void,
                 failedHandler: @escaping (PJNetwork.Error) -> Void) {
        PJNetwork.shared.requstWithGet(path: UserUrl.rcToken.rawValue,
                                       parameters: ["uid": uid], complement: {
                                        if $0["msgCode"]?.intValue == 0 {
                                            let res = $0["msg"]?.dictionary
                                            complateHandler(res!["token"]!.string!)
                                        } else {
                                            let error = PJNetwork.Error(errorCode: $0["msgCode"]?.intValue ?? 0, errorMsg: $0["msg"]?.string ?? "未知错误")
                                            failedHandler(error)
                                        }
        }) {
            failedHandler(PJNetwork.Error(errorCode: -1, errorMsg: $0))
        }
    }
    
    func connectRC(completeHandler: @escaping (String) -> Void,
                   failedHandler: @escaping (PJNetwork.Error) -> Void) {
        guard self.userModel.rcToken != nil else { return }
        RCIMClient.shared()?.connect(withToken: self.userModel.rcToken, success: { (userId) in
            completeHandler(userId ?? "无 uid")
        }, error: { (errorCode) in
            failedHandler(PJNetwork.Error(errorCode: -1,
                                          errorMsg: "融云IM 登录失败"))
        }, tokenIncorrect: {
            failedHandler(PJNetwork.Error(errorCode: -1,
                                          errorMsg: "融云IM token 失效"))
        })
    }
    
    func searchFriend(uid: String,
                      completeHandler: @escaping ([UserModel]) -> Void,
                      failedHandler: @escaping (PJNetwork.Error) -> Void) {
        let params = [
            "s_nick_name": uid
        ]
        PJNetwork.shared.requstWithGet(path: UserUrl.searchUser.rawValue, parameters: params, complement: { (dataDict) in
            if dataDict["msgCode"]?.intValue == 0 {
                let res = dataDict["msg"]?.dictionary
                let users = res!["users"]!.array!
                var final_us = [UserModel]()
                for u in users {
                    let d_u = u.dictionary!
                    let final_u = UserModel(nick_name: d_u["nick_name"]!.string!,
                                            gender: d_u["gender"]!.int!,
                                            avatar: d_u["avatar"]!.int!,
                                            token: nil,
                                            uid: d_u["uid"]!.int!,
                                            rcToken: nil)
                    final_us.append(final_u)
                }
                completeHandler(final_us)
            } else {
                let error = PJNetwork.Error(errorCode: dataDict["msgCode"]?.intValue ?? 0,errorMsg: dataDict["msg"]?.string ?? "未知错误")
                failedHandler(error)
            }
        }) { (errorString) in
            failedHandler(PJNetwork.Error(errorCode: -1, errorMsg: errorString))
        }
    }
    
    func friends(type: FriendType,
                 completeHandler: @escaping ([Any]) -> Void,
                 failedHandler: @escaping (PJNetwork.Error) -> Void) {
        let params = [
            "type": String(type.rawValue)
        ]
        PJNetwork.shared.requstWithGet(path: UserUrl.friends.rawValue, parameters: params, complement: { (dataDict) in
            if dataDict["msgCode"]?.intValue == 0 {
                let res = dataDict["msg"]?.dictionary
                let users = res!["friends"]!.array!
                var final_us = [Any]()
                for u in users {
                    let d_u = u.dictionary!
                    if type == .user {
                        let final_u = UserModel(nick_name: d_u["nick_name"]!.string!,
                                                gender: d_u["gender"]!.int!,
                                                avatar: d_u["avatar"]!.int!,
                                                token: nil,
                                                uid: d_u["uid"]!.int!,
                                                rcToken: nil)
                        final_us.append(final_u)
                    } else {
                        // 宠物详情
                    }
                    PJUser.shared.friends = final_us as! [PJUser.UserModel]
                    completeHandler(final_us)
                }
            } else {
                let error = PJNetwork.Error(errorCode: dataDict["msgCode"]?.intValue ?? 00,errorMsg: dataDict["msg"]?.string ?? "未知错误")
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
        /// 搜索用户
        case searchUser = "friend/search"
        /// 获取好友列表
        case friends = "friend/"
    }
}

extension PJUser {
    enum FriendType: Int {
        case user = 0
        case pet
    }
    struct UserModel: Codable {
        /// 昵称
        var nick_name: String
        /// 性别
        var gender: Int
        /// 头像索引
        var avatar: Int
        /// 校验 token
        var token: String?
        /// 用户唯一标识符
        var uid: Int
        /// 融云IM token
        var rcToken: String?
        
        init(nick_name: String? = nil, gender: Int? = nil, avatar: Int? = nil, token: String? = nil, uid: Int? = nil, rcToken: String? = nil) {
            self.nick_name = nick_name ?? ""
            self.gender = gender ?? 0
            self.avatar = avatar ?? -1
            self.token = token
            self.uid = uid ?? -1
            self.rcToken = rcToken
        }
    }
    
    // 用户注册时的中转 model
    struct UserRegisterModel {
        var nickName: String
        var phone: String
        var passwd: String
        var gender: Int
        var avatar: Int
    }
    
    /// 好友列表 model
    struct FriendModel {
        var user: UserModel
        var pet: PJRealPet.RealPetModel
    }
}
