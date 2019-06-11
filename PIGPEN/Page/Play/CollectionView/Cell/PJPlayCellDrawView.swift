//
//  PJPlayCellDrawView.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/6/11.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJPlayCellDrawView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        image = UIImage(named: "smile")
        
        let aPath = UIBezierPath(arcCenter: CGPoint(x: 14, y: 14), radius: 14,
                                 startAngle: 0,
                                 endAngle: (CGFloat)(90 * Double.pi / 180),
                                 clockwise: true)
        aPath.addLine(to: CGPoint(x: 14, y: 14))
        
        
        let maskLayer = CAShapeLayer(layer: layer)
        maskLayer.fillRule = .nonZero
        maskLayer.path = aPath.cgPath
        layer.mask = maskLayer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
