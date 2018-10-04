//
//  PJStatic.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/25.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

// 屏幕相关
let PJSCREEN_HEIGHT = Double(UIScreen.main.bounds.height)
let PJSCREEN_WIDTH = Double(UIScreen.main.bounds.width)
let NavigationItemMargin = CGFloat(8)
let PJTABBAR_HEIGHT = CGFloat(48)

// 颜色相关
func PJRGB(r: CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
}

// 判断是否为手机号
//- (BOOL)dealPhoneString:(NSString *)phoneString {
//    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    return [regextestmobile evaluateWithObject:phoneString];
//}

func isPhoneNumber(phoneString: String) -> Bool {
    let mobile = "^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$"
    let predicate = NSPredicate(format: "SELF MATCHES %@", mobile)
    return predicate.evaluate(with: phoneString)
}
