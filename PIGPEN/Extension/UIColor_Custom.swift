//
//  UIColor_Custom.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/3.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

extension UIColor {
    class func focusColor() -> UIColor {
        return PJRGB(r: 0, g: 155, b: 250)
    }
    
    class func unFocusColor() -> UIColor {
        return PJRGB(r: 230, g: 230, b: 230)
    }
    
    class func boderColor() -> UIColor {
        return PJRGB(r: 230, g: 230, b: 230)
    }
    
    class func pinkColor() -> UIColor {
        return PJRGB(r: 249, g: 162, b: 162)
    }
    
    class func backgroundColor() -> UIColor {
        return UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.4)
    }
    
    /// 评分组件-波浪前景色
    class func gradeForegroundColor() -> UIColor {
        return UIColor(red: 203/255.0, green: 235/255.0, blue: 255/255.0, alpha: 1)
    }
    
    /// 评分组件-波浪后景色
    class func gradeBackgroundColor() -> UIColor {
        return UIColor(red: 232/255.0, green: 246/255.0, blue: 255/255.0, alpha: 1)
    }
}
