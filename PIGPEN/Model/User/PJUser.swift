//
//  PJUser.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/29.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import Foundation


struct User {
    let phone: String?
    let nickName: String?
    let gender: Int?
    let avatar: Int?
    
}

class PJUser {
    static let shared = PJUser()
 
    var model: User
    var token: String
    
    init() {
        model = User(phone: "", nickName: "", gender: 1, avatar: -1)
        token = ""
    }
    
    
    func update(userModel: User, token: String) {
        model = userModel
        self.token = token
        
        saveToSandBox()
    }
    
    
    func login(phone: String, passwd: String) {
        let parameters = [
            "username": "18877566676",
//            "timestamp": 
        ]
        PJNetwork.shared.requstWithGet(parametes: parameters, complement: { (dataArray) in
            
        }) { (errorString) in
            
        }
    }
    
    
    func logout() {
        model = User(phone: "", nickName: "", gender: 1, avatar: -1)
        token = ""
        
        saveToSandBox()
    }
    
    
    private func saveToSandBox() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                        .userDomainMask,
                                                        true)
        let documentsDirectory = paths[0]
        let path = documentsDirectory + "UserStore.plist"
        let userData = NSKeyedArchiver.archivedData(withRootObject: self)
        try? userData.write(to: URL(string: path)!, options: NSData.WritingOptions.atomic)
    }
    
}
