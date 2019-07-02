//
//  PJBottomSelectedButtonView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/24.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJBottomSelectedButtonView: UIView {

    var firstSelected: (() -> Void)?
    var secondSelected: (() -> Void)?
    
    private var viewModel = ViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, viewModel: ViewModel) {
        self.init(frame: frame)
        self.viewModel = viewModel
        initView()
    }
    
    private func initView() {
        backgroundColor = .clear
        
        let firstButton = UIButton(frame: CGRect(x: 0, y: 0, width: 104, height: 40))
        addSubview(firstButton)
        firstButton.setTitle(viewModel.firstValue, for: .normal)
        firstButton.setBackgroundImage(UIImage(named: "grey_bg"), for: .normal)
        firstButton.setTitleColor(.black, for: .normal)
        firstButton.addTarget(self, action: .firstAction, for: .touchUpInside)
        firstButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        firstButton.adjustsImageWhenHighlighted = false
        
        let secondButton = UIButton(frame: CGRect(x: 0, y: 0, width: firstButton.pj_width, height: firstButton.pj_height))
        addSubview(secondButton)
        secondButton.setTitle(viewModel.secondValue, for: .normal)
        secondButton.setBackgroundImage(UIImage(named: "orange_bg"), for: .normal)
        secondButton.setTitleColor(.white, for: .normal)
        secondButton.addTarget(self, action: .secondAction, for: .touchUpInside)
        secondButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        secondButton.adjustsImageWhenHighlighted = false
        
        let innerWidth = (pj_width - firstButton.pj_width * 2) / 3
        firstButton.left = innerWidth
        secondButton.left = innerWidth + firstButton.right
    }
    
}

extension PJBottomSelectedButtonView {
    @objc
    fileprivate func firstAction() {
        firstSelected?()
    }
    
    @objc
    fileprivate func secondAction() {
        secondSelected?()
    }
}

private extension Selector {
    static let firstAction = #selector(PJBottomSelectedButtonView.firstAction)
    static let secondAction = #selector(PJBottomSelectedButtonView.secondAction)
}

extension PJBottomSelectedButtonView {
    struct ViewModel {
        var firstValue: String
        var secondValue: String
        
        init() {
            firstValue = ""
            secondValue = ""
        }
    }
}
