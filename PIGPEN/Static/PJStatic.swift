//
//  PJStatic.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/25.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.main.bounds.size.width
let screentHeight = UIScreen.main.bounds.size.height
// 底部安全距离
let bottomSafeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0
//顶部的安全距离
let topSafeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0.0
//状态栏高度
let statusBarHeight = UIApplication.shared.statusBarFrame.height;
//导航栏高度
let navigationBarHeight = CGFloat(44 + topSafeAreaHeight)

let sideMenuWidth = screenWidth * 0.4

// 屏幕相关
let PJSCREEN_HEIGHT = CGFloat(UIScreen.main.bounds.height)
let PJSCREEN_WIDTH = CGFloat(UIScreen.main.bounds.width)
let NavigationItemMargin = CGFloat(8)
let PJTABBAR_HEIGHT = CGFloat(48) + bottomSafeAreaHeight


// 颜色相关
func PJRGB(_ r: CGFloat, _ g:CGFloat, _ b:CGFloat) -> UIColor {
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
}

func PJRGBA(_ r: CGFloat, _ g:CGFloat, _ b:CGFloat, _ a: CGFloat) -> UIColor {
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

func isPhoneNumber(phoneString: String) -> Bool {
    let mobile = "^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$"
    let predicate = NSPredicate(format: "SELF MATCHES %@", mobile)
    return predicate.evaluate(with: phoneString)
}

/// debug 模式下才能执行的代码块
func debugOnly(_ body: () -> Void) {
    assert({body(); return true}())
}

/// 当前 vc 如果是 push 则 pop，反之 dismiss
func dissmisCurrentVC(navc: UINavigationController?,
                      currenVC: UIViewController) {
    guard let navc = navc else {
        currenVC.dismiss(animated: true, completion: nil)
        return
    }
    let vcs = navc.viewControllers
    if vcs.count > 1 && vcs[vcs.count - 1] === currenVC {
        navc.popViewController(animated: true)
    } else {
        currenVC.dismiss(animated: true, completion: nil)
    }
}

/// 判断当前 vc 是 push 还是 pop 进来
func currenVCFromPush(navc: UINavigationController?,
                      currenVC: UIViewController) -> Bool {
    guard let navc = navc else { return false }
    let vcs = navc.viewControllers
    if vcs.count > 1 && vcs[vcs.count - 1] === currenVC {
        return true
    } else {
        return false
    }
}

func windowFromLevel(level: UIWindow.Level) -> UIWindow? {
    let windows = UIApplication.shared.windows
    for window in windows {
        if (level == window.windowLevel) {
            return window
        }
    }
    return nil
}

/// 字典转模型
///
/// - parameter model: 模型对象
/// - parameter data: 字典
func dataConvertToModel<T: Codable>(_ model: T, from data: Data) -> T? {
    do {
        return try JSONDecoder().decode(T.self, from: data)
    } catch {
        debugOnly {
            print("dataConvertToModel JSONDecoder error:\(error.localizedDescription)")
        }
        assert(true, "dataConvertToModel JSONDecoder error:\(error.localizedDescription)")
    }
    return nil
}

public func delay(by delayTime: TimeInterval, qosClass: DispatchQoS.QoSClass? = nil,
                  _ closure: @escaping () -> Void) {
    let dispatchQueue = qosClass != nil ? DispatchQueue.global(qos: qosClass!) : .main
    dispatchQueue.asyncAfter(deadline: DispatchTime.now() + delayTime, execute: closure)
}
