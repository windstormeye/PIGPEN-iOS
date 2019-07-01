//
//  PJManualAddKcalView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/23.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJManualAddKcalView: UIView {
    var pickCount  = 0 {
        didSet {
            rulerView.pickCount = pickCount
        }
    }
    
    var itemSelected: ((Int) -> Void)?
    
    private var rulerView = PJRulerPickerView()
    private var tipsString = ""
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, pickCount: Int, tipsText: String) {
        self.init(frame: frame)
        self.pickCount = pickCount
        self.tipsString = tipsText
        initView()
    }
    
    private func initView() {
        isUserInteractionEnabled = true
        backgroundColor = .white
        
        let kcalLabel = UILabel(frame: CGRect(x: 0, y: 0, width: pj_width, height: pj_height / 2))
        addSubview(kcalLabel)
        kcalLabel.font = UIFont.systemFont(ofSize: 24)
        kcalLabel.textAlignment = .center
        kcalLabel.centerX = centerX
        
        let kcalString = " " + tipsString
        let kcalAttribute = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let kcalAttrString = NSAttributedString(string: kcalString, attributes: kcalAttribute)
        
        let numberString = String(0)
        let numberAttribute = [NSAttributedString.Key.foregroundColor: PJRGB(255, 85, 67)]
        let numberAttrString = NSMutableAttributedString(string: numberString, attributes: numberAttribute)
        
        numberAttrString.append(kcalAttrString)
        kcalLabel.attributedText = numberAttrString
        
        rulerView = PJRulerPickerView(frame: CGRect(x: 0, y: kcalLabel.bottom, width: pj_width, height: pj_height / 2), pickCount: pickCount)
        addSubview(rulerView)
        rulerView.moved = {
            self.itemSelected?($0)
            
            let kcalString = " " + self.tipsString
            let kcalAttribute = [NSAttributedString.Key.foregroundColor: UIColor.black]
            let kcalAttrString = NSAttributedString(string: kcalString, attributes: kcalAttribute)
            
            let numberString = String($0)
            let numberAttribute = [NSAttributedString.Key.foregroundColor: PJRGB(255, 85, 67)]
            let numberAttrString = NSMutableAttributedString(string: numberString, attributes: numberAttribute)
            
            numberAttrString.append(kcalAttrString)
            kcalLabel.attributedText = numberAttrString
        }
    }
}
