//
//  Double.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/19.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import Foundation

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
