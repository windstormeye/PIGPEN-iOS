//
//  PJPetPlayDetailsView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/15.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJPetPlayDetailsView: UIView {

    @IBOutlet weak var dayTargetLabel: UILabel!
    @IBOutlet weak var timesLabel: UILabel!
    @IBOutlet weak var todayTimesLabel: UILabel!
    @IBOutlet weak var circleView: UIView!
    
    class func newInstance() -> PJPetPlayDetailsView {
        return Bundle.main.loadNibNamed("PJPetPlayDetailsView",
                                        owner: self,
                                        options: nil)?.first! as! PJPetPlayDetailsView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        circleOfDots(view: circleView)
    }
    
    private func circleOfDots(view: UIView) {
        let score = CGFloat(8.5)
        let startAngle = -CGFloat.pi * 0.5
        let endAngle = -(CGFloat.pi * 2 * 0.1 * score) + startAngle
        let radius = CGFloat(22.5)
        
        let backCirclePath = UIBezierPath(arcCenter: CGPoint(x: 0,y: 0),
                                          radius: radius,
                                          startAngle: endAngle,
                                          endAngle: startAngle,
                                          clockwise: false)
        let backShapeLayer = CAShapeLayer()
        backShapeLayer.path = backCirclePath.cgPath
        backShapeLayer.position = CGPoint(x: view.bounds.midX ,y: view.bounds.midY)
        backShapeLayer.fillColor = UIColor.clear.cgColor
        backShapeLayer.strokeColor = UIColor.white.cgColor
        backShapeLayer.lineWidth = 4
        backShapeLayer.lineDashPattern = [1, 6]
        backShapeLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(backShapeLayer)
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 0,y: 0),
                                      radius: radius,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: false)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.position = CGPoint(x: view.bounds.midX ,y: view.bounds.midY)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = PJRGB(255, 85, 67).cgColor
        //you can change the line width
        shapeLayer.lineWidth = 4
        shapeLayer.lineDashPattern = [1, 6]
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(shapeLayer)
    }
}
