//
//  Date.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/1/2.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import Foundation

extension Date {
    /// 获取当前 秒级 时间戳 - 10位
    var secondStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        return "\(Int(timeInterval))"
    }
    
    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
}
