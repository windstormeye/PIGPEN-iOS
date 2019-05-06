//
//  String_time.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/3.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import Foundation


extension String {
    static func timestampe() -> String {
        let dataNow = Date()
        var finishDate = Int(dataNow.timeIntervalSince1970)
        finishDate = finishDate / 300
        return "\(finishDate)"
    }
    
    /// 获取字符串中连续的数字
    func regexNumber() -> String {
        var productIdString = ""
        let regex = try! NSRegularExpression(pattern: "[0-9]*",
                                             options:[])
        let matches = regex.matches(in: self,
                                    options: [],
                                    range: NSRange(self.startIndex..., in: self))
        for match in matches {
            let startIndex = String.Index(utf16Offset: 0, in: self)
            let endIndex = String.Index(utf16Offset: match.numberOfRanges - 1, in: self)
            productIdString = String(self[startIndex...endIndex])
        }
        return productIdString
    }
}
