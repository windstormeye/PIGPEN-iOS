//
//  PJUser.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/29.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import Foundation
import CryptoSwift


enum UserUrl: String {
    case register = "masuser/createmasuser"
    case logIn = "masuser/login"
    case update = "masuser/logout"
    case logOut = "masuser/update"
    case updateToken = "masuser/updateToken"
    case details = "masuser/getUserDetails"
}


struct PJUserModel {
    let nickName: String?
    let gender: Int?
    let avatar: Int?
}


class PJUser: Codable {
    static let shared = PJUser()
    
    let userAccountPath =  NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
    
    var nickName: String? = ""
    var gender: Int? = 0
    var avatar: Int? = -1
    var token: String? = ""
    
    init() {
        nickName = ""
        gender = 1
        avatar = -1
        token = ""
        let user = self.readBySandBox()
        if user != nil {
            nickName = user?.nickName
            gender = user?.gender
            avatar = user?.avatar
            token = user?.token
        }
    }
    
    
    func details(nickName: String,
                 completeHandler: @escaping (PJUserModel) -> Void,
                 failedHandler: @escaping (PJError) -> Void) {
        let parameters = [
            "nick_name": nickName,
        ]
        PJNetwork.shared.requstWithPost(path: UserUrl.details.rawValue,
                                        parameters: parameters,
                                        complement: { (dataDic) in
                                            if dataDic["msgCode"]?.intValue == 666 {
                                                var dataDic = dataDic["msg"]!
                                                let userDic = dataDic["masuser"].dictionary!
                                                let gender = userDic["gender"]?.intValue
                                                let nickName = userDic["nick_name"]?.string
                                                let avatar = userDic["avatar"]?.intValue
                                                let user = PJUserModel(nickName: nickName,
                                                                       gender: gender,
                                                                       avatar: avatar)
                                                completeHandler(user)
                                            } else {
                                                let error = PJError(errorCode: dataDic["msgCode"]?.intValue,
                                                                    errorMsg: dataDic["msg"]?.string)
                                                failedHandler(error)
                                            }
        }) { (errorString) in
            failedHandler(PJError(errorCode: 0,
                                  errorMsg: "未知错误"))
        }
    }
    
    
    func update(avatar: Int,
                gender: Int,
                completeHandler: @escaping () -> Void,
                failedHandler: @escaping (PJError) -> Void) {
        let parameters = [
            "avatar": String(avatar),
            "gender": String(gender)
        ]
        PJNetwork.shared.requstWithPost(path: UserUrl.update.rawValue,
                                        parameters: parameters,
                                        complement: { (dataDic) in
                                            if dataDic["msgCode"]?.intValue == 666 {
                                                self.logout()
                                                
                                                var dataDic = dataDic["msg"]!
                                                let userDic = dataDic["masuser"].dictionary!
                                                self.gender = userDic["gender"]?.intValue
                                                self.avatar = userDic["avatar"]?.intValue
                                                
                                                self.saveToSandBox()
                                                completeHandler()
                                            } else {
                                                let error = PJError(errorCode: dataDic["msgCode"]?.intValue,
                                                                    errorMsg: dataDic["msg"]?.string)
                                                failedHandler(error)
                                            }
        }) { (errorString) in
            failedHandler(PJError(errorCode: 0,
                                  errorMsg: "未知错误"))
        }
    }
    
    
    func register(phone: String,
                  passwd: String,
                  nickName: String,
                  avatar: Int,
                  gender: Int,
                  completeHandler: @escaping () -> Void,
                  failedHandler: @escaping (PJError) -> Void) {
        let salt = String(phone.reversed())
        var psd = passwd + salt
        psd = psd.md5()
        
        let parameters = [
            "username": phone,
            "password": psd
        ]
        PJNetwork.shared.requstWithPost(path: UserUrl.register.rawValue,
                                        parameters: parameters,
                                        complement: { (dataDic) in
                                            if dataDic["msgCode"]?.intValue == 666 {
                                                self.logout()
                                                
                                                var dataDic = dataDic["msg"]!
                                                let userDic = dataDic["masuser"].dictionary!
                                                self.nickName = userDic["nick_name"]?.string
                                                self.gender = userDic["gender"]?.intValue
                                                self.avatar = userDic["avatar"]?.intValue
                                                self.token = dataDic["token"].string!
                                                
                                                self.saveToSandBox()
                                                completeHandler()
                                            } else {
                                                let error = PJError(errorCode: dataDic["msgCode"]?.intValue,
                                                                    errorMsg: dataDic["msg"]?.string)
                                                failedHandler(error)
                                            }
        }) { (errorString) in
            failedHandler(PJError(errorCode: 0,
                                  errorMsg: "未知错误"))
        }
    }
    
    
    func login(phone: String,
               passwd: String,
               completeHandler: @escaping () -> Void,
               failedHandler: @escaping (PJError) -> Void) {
        let salt = String(phone.reversed())
        var psd = passwd + salt
        psd = psd.md5()
        var sign = psd + String.timestape()
        sign = sign.md5()
        
        let parameters = [
            "username": phone,
            "sign": sign,
        ]
        PJNetwork.shared.requstWithPost(path: UserUrl.logIn.rawValue,
                                        parameters: parameters,
                                        complement: { (dataDic) in
                                            if dataDic["msgCode"]?.intValue == 666 {
                                                self.logout()
                                                
                                                var dataDic = dataDic["msg"]!
                                                let userDic = dataDic["masuser"].dictionary!
                                                self.nickName = userDic["nick_name"]?.string
                                                self.gender = userDic["gender"]?.intValue
                                                self.avatar = userDic["avatar"]?.intValue
                                                self.token = dataDic["token"].string!
                                                
                                                self.saveToSandBox()
                                                completeHandler()
                                            } else {
                                                let error = PJError(errorCode: dataDic["msgCode"]?.intValue,
                                                                    errorMsg: dataDic["msg"]?.string)
                                                failedHandler(error)
                                            }
        }, failed: { (errorString) in
            failedHandler(PJError(errorCode: 0,
                                  errorMsg: "未知错误"))
        })
    }
    
    
    func logout() {
        nickName = ""
        gender = 1
        avatar = -1
        token = ""
        // 可能在多个 page 下进行登出，然后再登录时账户信息错误
        saveToSandBox()
    }
    
    
    private func saveToSandBox() {
        let encoder = JSONEncoder()
        if let BeerData = try? encoder.encode(self) {
            let url = URL.init(fileURLWithPath: userAccountPath).appendingPathComponent("userData.data")
            do {
                try BeerData.write(to: url)
                print("完成了对数据的二进制化归档")
            } catch {
                print(error)
            }
        }
    }
    
    
    private func readBySandBox() -> PJUser? {
        let url = URL.init(fileURLWithPath: userAccountPath).appendingPathComponent("userData.data")
        do {
            let data = try FileHandle.init(forReadingFrom: url)
            do {
                let user = try JSONDecoder().decode(PJUser.self,
                                                         from: data.readDataToEndOfFile())
                return user
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        return nil
    }
}
