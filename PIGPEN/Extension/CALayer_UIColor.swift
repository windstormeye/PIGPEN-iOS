//
//  CALayer_UIColor.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/1.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

extension CALayer {
    func setBoderColorWithUIColor(_ color: UIColor) {
        self.borderColor = color.cgColor
    }
    
}
