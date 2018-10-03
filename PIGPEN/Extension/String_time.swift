//
//  String_time.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/3.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import Foundation


extension String {
    static func timestape() -> String {
        let dataNow = Date()
        var finishDate = Int(dataNow.timeIntervalSince1970)
        finishDate = finishDate / 300
        return "\(finishDate)"
    }
}
