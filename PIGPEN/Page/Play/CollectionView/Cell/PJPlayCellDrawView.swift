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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, imageName: String, score: CGFloat) {
        self.init(frame: frame)
        
        backgroundColor = .clear
        image = UIImage(named: imageName)
        contentMode = .scaleAspectFit
        
        let aPath = UIBezierPath(arcCenter: CGPoint(x: centerX + 7, y: centerY), radius: pj_height,
                                 startAngle: (CGFloat)(-90 * Double.pi / 180),
                                 endAngle: (score * 3.6 - 90) * CGFloat.pi / 180,
                                 clockwise: false)
        aPath.addLine(to: CGPoint(x: centerX + 7, y: centerY))
        
        
        let maskLayer = CAShapeLayer(layer: layer)
        maskLayer.fillRule = .nonZero
        maskLayer.path = aPath.cgPath
        layer.mask = maskLayer
    }
}
