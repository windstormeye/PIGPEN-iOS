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


// 当前 vc 如果是 push 则 pop，反之 dismiss
func dissmisCurrentVC(navc: UINavigationController?,
                      currenVC: UIViewController) {
    guard navc != nil else {
        currenVC.dismiss(animated: true, completion: nil)
        return
    }
    let vcs = navc!.viewControllers
    if vcs.count > 1 && vcs[vcs.count - 1] === currenVC {
        navc!.popViewController(animated: true)
    } else {
        currenVC.dismiss(animated: true, completion: nil)
    }
}

func currenVCFromPush(navc: UINavigationController?,
                      currenVC: UIViewController) -> Bool {
    guard navc != nil else {
        return false
    }
    let vcs = navc!.viewControllers
    if vcs.count > 1 && vcs[vcs.count - 1] === currenVC {
        return true
    } else {
        return false
    }
}
