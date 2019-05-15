//
//  UIButton.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/5/9.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import Foundation

extension UIButton {
    func topImageBottomTitle(titleTop: CGFloat) {
        imageEdgeInsets = UIEdgeInsets(top: -imageView!.pj_height / 2, left: titleLabel!.bounds.size.width / 2, bottom: 0, right: -titleLabel!.bounds.size.width / 2);
        let titleTop = titleLabel!.pj_height / 2 + imageView!.pj_height / 2 + titleTop
        titleEdgeInsets = UIEdgeInsets(top: titleTop, left: -imageView!.bounds.size.width, bottom: 0, right: 0);
    }
    
    func defualtStyle(_ title: String?) {
        layer.cornerRadius = self.pj_height / 2
        backgroundColor = PJRGB(255, 85, 67)
        if title != nil {
            setTitle(title, for: .normal)
        }
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }
}
