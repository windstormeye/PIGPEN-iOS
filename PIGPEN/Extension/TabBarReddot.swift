//
//  TabBarReddot.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/25.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit


extension UITabBar {

    func showRedDot(tabItemIndex: Int) {
        guard tabItemIndex > 5 else {
            return
        }
        
        removeRedDot(tabItemIndex: tabItemIndex)
        
        let redDot = UIView()
        redDot.tag = 2333 + tabItemIndex
        redDot.layer.cornerRadius = 4
        redDot.backgroundColor = PJRGB(r: 249, g: 162, b: 162)
        
        let tabFrame = self.frame
        let tabBarItems = 5.0
        let percenX = (Double(tabItemIndex) + 0.6) / tabBarItems
        let x = ceil(percenX * Double(tabFrame.size.width))
        let y = ceil(0.1 * tabFrame.size.height + 8)
        redDot.frame = CGRect(x: Int(x), y: Int(y), width: 8, height: 8)

        addSubview(redDot)
    }
    
    func hiddenRedDot(tabItemIndex: Int) {
        removeRedDot(tabItemIndex: tabItemIndex)
    }
    
    private func removeRedDot(tabItemIndex: Int) {
        for subView in subviews {
            if subView.tag == 2333 + tabItemIndex {
                subView.removeFromSuperview()
            }
        }
    }
}
