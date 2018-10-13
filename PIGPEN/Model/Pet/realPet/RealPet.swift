//
//  Pet.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/8.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import Foundation

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

class RealPet {
    var model: RealPetModel?
    
    
}
