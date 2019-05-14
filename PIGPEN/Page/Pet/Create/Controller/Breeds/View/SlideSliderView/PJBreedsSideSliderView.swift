//
//  PJBreedsSideSliderView.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/11/10.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJBreedsSideSliderView: UIView {

    var selectedComplation: ((Int) -> Void)?
    var itemStrings = [String]() {
        didSet {
            didSetItemString()
        }
    }
    
    let buttonHeight: CGFloat = 25

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    private func initView() {
        backgroundColor = .boderColor
        isUserInteractionEnabled = true
        
        let pan = UIPanGestureRecognizer(target: self, action: .pan)
        addGestureRecognizer(pan)
    }

    // MARK: - Actions
    private func didSetItemString() {
        var index = 0
        for item in itemStrings {
            let button = UIButton(frame: CGRect(x: 0,
                                                y: CGFloat(index) * buttonHeight,
                                                width: pj_width,
                                                height: buttonHeight))
            button.setTitle(item, for: .normal)
            button.tag = index
            button.addTarget(self,
                             action: .buttonSelected,
                             for: .touchUpInside)
            button.titleLabel?.textColor = .white
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            addSubview(button)
            index += 1
        }
    }

    @objc fileprivate func buttonSelected(button: UIButton) {
        if selectedComplation != nil {
            selectedComplation!(button.tag)
        }
    }
    
}

private extension Selector {
    static let pan = #selector(PJBreedsSideSliderView.pan(panGesture:))
    static let buttonSelected = #selector(PJBreedsSideSliderView.buttonSelected(button:))
}


extension PJBreedsSideSliderView {
    @objc
    fileprivate func pan(panGesture: UIPanGestureRecognizer) {
        var point = panGesture.location(in: self)
        
        if point.y < 0 {
            point.y = 0
        }
        
        var index = Int(point.y / buttonHeight)
        
        if index > itemStrings.count - 1 {
            index = itemStrings.count - 1
        }
        
        selectedComplation?(index)
    }
}
