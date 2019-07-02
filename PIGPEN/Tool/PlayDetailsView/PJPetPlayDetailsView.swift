//
//  PJPetPlayDetailsView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/15.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJPetPlayDetailsView: UIView {

    var viewModel = ViewModel() {
        didSet {
            firstLabel.text = viewModel.firstString
            secondLabel.text = viewModel.secondString
            thirdLabel.text = viewModel.thirdString
            circleOfDots(view: circleView, score: viewModel.score)
        }
    }
    
    private var shapeLayer = CAShapeLayer()
    private var backShapeLayer = CAShapeLayer()
    
    @IBOutlet private weak var firstLabel: UILabel!
    @IBOutlet private weak var secondLabel: UILabel!
    @IBOutlet private weak var thirdLabel: UILabel!
    @IBOutlet private weak var circleView: UIView!
    @IBOutlet private weak var firstTextLabel: UILabel!
    @IBOutlet private weak var secondTextLabel: UILabel!
    @IBOutlet private weak var thirdTextLabel: UILabel!
    
    class func newInstance() -> PJPetPlayDetailsView {
        return Bundle.main.loadNibNamed("PJPetPlayDetailsView",
                                        owner: self,
                                        options: nil)?.first! as! PJPetPlayDetailsView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backShapeLayer.fillColor = UIColor.clear.cgColor
        backShapeLayer.strokeColor = UIColor.white.cgColor
        backShapeLayer.lineWidth = 4
        backShapeLayer.lineDashPattern = [1, 6]
        backShapeLayer.lineCap = CAShapeLayerLineCap.round
        circleView.layer.addSublayer(backShapeLayer)
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = PJRGB(255, 85, 67).cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.lineDashPattern = [1, 6]
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        circleView.layer.addSublayer(shapeLayer)
    }
    
    func updateLabel(firstString: String, secondString: String, thirdString: String) {
        firstTextLabel.text = firstString
        secondTextLabel.text = secondString
        thirdTextLabel.text = thirdString
    }
    
    private func circleOfDots(view: UIView, score: CGFloat) {
        let startAngle = -CGFloat.pi * 0.5
        let endAngle = -(CGFloat.pi * 2 * 0.1 * score) + startAngle
        let radius = CGFloat(22.5)
        
        let backCirclePath = UIBezierPath(arcCenter: CGPoint(x: 0,y: 0),
                                          radius: radius,
                                          startAngle: endAngle,
                                          endAngle: startAngle,
                                          clockwise: false)
        backShapeLayer.path = backCirclePath.cgPath
        backShapeLayer.position = CGPoint(x: view.bounds.midX ,y: view.bounds.midY)
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 0,y: 0),
                                      radius: radius,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: false)
        shapeLayer.path = circlePath.cgPath
        shapeLayer.position = CGPoint(x: view.bounds.midX ,y: view.bounds.midY)
    }
}

extension PJPetPlayDetailsView {
    struct ViewModel {
        var firstString: String
        var secondString: String
        var thirdString: String
        var score: CGFloat
        
        init() {
            firstString = ""
            secondString = ""
            thirdString = ""
            score = 0
        }
    }
}
