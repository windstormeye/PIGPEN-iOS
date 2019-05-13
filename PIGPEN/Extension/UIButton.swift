//
//  UIButton.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/5/9.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import Foundation

extension UIButton {
    static func topImageBottomTitle(button: UIButton, titleTop: CGFloat) {
        button.titleEdgeInsets = UIEdgeInsets(top: button.imageView!.frame.size.height + titleTop, left: -button.imageView!.bounds.size.width, bottom: 0, right: 0);
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: button.titleLabel!.bounds.size.width / 2, bottom: 0, right: -button.titleLabel!.bounds.size.width / 2);
//        button.contentEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 20.0, right: 0)
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
