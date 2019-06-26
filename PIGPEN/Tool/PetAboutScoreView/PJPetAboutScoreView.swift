//
//  PJPetAboutScoreView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/24.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJPetAboutScoreView: UIView {

    var viewModel = ViewModel() {
        didSet {
            initView()
        }
    }
    
    lazy var scoreX = (pj_width - 40) / 100 * viewModel.score * 10
    
    @IBOutlet private weak var firstValue: UILabel!
    @IBOutlet private weak var firstTextLabel: UILabel!
    @IBOutlet private weak var secondValue: UILabel!
    @IBOutlet private weak var secondTextLabel: UILabel!
    @IBOutlet private weak var thirdValue: UILabel!
    @IBOutlet private weak var thirdTextLabel: UILabel!
    
    class func newInstance() -> PJPetAboutScoreView {
        return Bundle.main.loadNibNamed("PJPetAboutScoreView", owner: self, options: nil)?.first as! PJPetAboutScoreView
    }
    
    private func initView() {
        firstValue.text = viewModel.firstValue
        secondValue.text = viewModel.secondValue
        thirdValue.text = viewModel.thirdValue
        
        let dogImageView = UIImageView(frame: CGRect(x: 20, y: 10, width: 56, height: 30))
        addSubview(dogImageView)
        dogImageView.image = UIImage(named: "pet_play_about_dog")
        
        let backLineView = UIView(frame: CGRect(x: 20, y: dogImageView.bottom + 7, width: pj_width - 40, height: 3))
        addSubview(backLineView)
        
        let backLineShapeLayer = CAShapeLayer()
        backLineShapeLayer.bounds = backLineView.bounds
        backLineShapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        backLineShapeLayer.strokeColor = UIColor.white.cgColor
        backLineShapeLayer.lineWidth = backLineView.pj_height
        backLineShapeLayer.lineJoin = .round
        backLineShapeLayer.lineCap = .round
        backLineShapeLayer.lineDashPattern = [1, 6]
        
        let bakLinePath = CGMutablePath()
        bakLinePath.move(to: CGPoint(x: 40, y: dogImageView.bottom + 7))
        bakLinePath.addLine(to: CGPoint(x: backLineView.pj_width, y: dogImageView.bottom + 7))
    
        backLineShapeLayer.path = bakLinePath
        layer.addSublayer(backLineShapeLayer)
        
        let foreLineView = UIView(frame: CGRect(x: 20, y: dogImageView.bottom + 7, width: pj_width - 40, height: 3))
        addSubview(foreLineView)
        
        let foreShapeLayer = CAShapeLayer()
        foreShapeLayer.bounds = foreLineView.bounds
        foreShapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        foreShapeLayer.strokeColor = PJRGB(255, 85, 67).cgColor
        foreShapeLayer.lineWidth = backLineView.frame.size.height
        foreShapeLayer.lineJoin = .round
        foreShapeLayer.lineCap = .round
        foreShapeLayer.lineDashPattern = [1, 6]
        
        let forePath = CGMutablePath()
        forePath.move(to: CGPoint(x: 40, y: dogImageView.bottom + 7))
        forePath.addLine(to: CGPoint(x: 40 + scoreX, y: dogImageView.bottom + 7))
        
        if scoreX - 5 < 40 {
            dogImageView.x = 40
        } else {
            dogImageView.centerX = scoreX - 5
        }
        
        foreShapeLayer.path = forePath
        layer.addSublayer(foreShapeLayer)
    }
}

extension PJPetAboutScoreView {
    struct ViewModel {
        var score: CGFloat
        var firstValue: String
        var secondValue: String
        var thirdValue: String
        
        init() {
            score = 0
            firstValue = "-"
            secondValue = "-"
            thirdValue = "-"
        }
    }
}
