//
//  Pet.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/8.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import Foundation

enum RealPetUrl: String {
    case breeds = "realPet/breeds"
}

struct RealPetModel: Codable {
    var user_name: String?
    var nick_name: String?
    var gender: Int?
    var pet_type: String?
    var weight: String?
    var ppp_status: Int?
    var love_status: Int?
    var family_relation: Int?
    var birth_time: String?
}

struct RealPetBreedModel: Codable {
    var id: Int?
    var zh_name: String?
}

class RealPet {
    var model: RealPetModel?
    
    class func breedList(petType: String) {
        let parameters = [
            "nick_name": PJUser.shared.nickName ?? "",
            "pet_type": petType
            ]
        PJNetwork.shared.requstWithGet(path: RealPetUrl.breeds.rawValue,
                                       parameters: parameters,
                                       complement: { (dataDic) in
                                      print(dataDic)
        }) { (errorString) in
            
        }
    }
}
