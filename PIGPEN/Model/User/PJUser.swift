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
    static let shared = PJUser()
    static let userAccountPath =  NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
    
    /// 用户数据模型
    var userModel = UserModel()
    /// 用户宠物列表
    var pets = [PJPet.Pet]()
    /// 是否已经拉起登录
    var isLogin = false
    /// 用户好友列表
    var friends = [UserModel]()
    
    init() {
        userModel = readBySandBox() ?? UserModel()
        pets = readPetDataBySandBox() ?? [PJPet.Pet]()
    }
}
