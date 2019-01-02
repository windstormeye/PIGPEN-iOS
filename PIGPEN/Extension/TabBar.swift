//
//  TabBarReddot.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/25.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

// MARK: - Reddot
extension UITabBar {
    /// 只显示点，不显示数字
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

// MARK: - bottomLine
extension UITabBar {
    func showBottomLine(in selectedIndex: Int) {
        var bottomLineView: UIView?
        
        for view in self.subviews {
            if view.tag == 666 {
                bottomLineView = view
            }
        }
        
        let l_x = (3.0 * CGFloat(selectedIndex + 1) - 2.0) * PJSCREEN_WIDTH / CGFloat(self.items!.count * 3) - 2.5
        if bottomLineView == nil {
            let l_y = CGFloat(40)
            let l_h = CGFloat(2)
            let l_w = CGFloat(30)
            
            bottomLineView = UIView(frame: CGRect(x: l_x, y: l_y, width: l_w, height: l_h))
            bottomLineView?.tag = 666
            bottomLineView?.backgroundColor = PJRGB(r: 249, g: 162, b: 162)
            self.addSubview(bottomLineView!)
        } else {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                bottomLineView?.x = l_x
            }) { (finished) in
                if finished {
                    
                }
            }
        }
    }
}

