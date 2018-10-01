//
//  PJStatic.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/25.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

// 屏幕相关
let PJSCREEN_HEIGHT = CGFloat(UIScreen.main.bounds.height)
let PJSCREEN_WIDTH = CGFloat(UIScreen.main.bounds.width)
let NavigationItemMargin = CGFloat(8)
let PJTABBAR_HEIGHT = CGFloat(48)

// 颜色相关
func PJRGB(r: CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
}
