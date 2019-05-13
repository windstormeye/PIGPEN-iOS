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
    var userModel = UserModel()
    /// 是否已经拉起登录
    var isLogin = false
    /// 用户好友列表
    var friends = [UserModel]()
    
    // MARK: - Private Methods
    static let userAccountPath =  NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
    
    // MARK: - Life Cycle
    init() {
        let u = self.readBySandBox()
        if u != nil {
            userModel = u!
        } else {
            userModel = UserModel(nick_name: "",
                                  gender: 0,
                                  avatar: -1,
                                  token: nil,
                                  uid: -1,
                                  rcToken: nil)
        }
    }
}
