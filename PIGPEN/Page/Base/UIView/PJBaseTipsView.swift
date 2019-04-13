//
//  PJBaseTipsView.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/1.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJBaseTipsView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    private func initView() {
        layer.shadowColor = PJRGB(200, 200, 200).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 1
        layer.shadowRadius = 8
        
        layer.borderColor = PJRGB(230, 230, 230).cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 8
    }
    
}
