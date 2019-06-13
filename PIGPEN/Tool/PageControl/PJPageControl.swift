//
//  PJPageControl.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/13.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJPageControl: UIPageControl {

    override func layoutSubviews() {
        let dotW = 7
        let dotMargin = 8
        let marginX = dotW + dotMargin
        
        for (index, view) in subviews.enumerated() {
            view.frame = CGRect(x: index * marginX, y: 0, width: dotW, height: dotW)
        }
    }

}
