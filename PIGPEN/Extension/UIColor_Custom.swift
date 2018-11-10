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
}
