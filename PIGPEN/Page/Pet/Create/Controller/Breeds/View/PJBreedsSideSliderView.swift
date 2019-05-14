//
//  PJBreedsSideSliderView.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/11/10.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let buttonSelected = #selector(PJBreedsSideSliderView.buttonSelected(button:))
}

class PJBreedsSideSliderView: UIView {

    var selectedComplation: ((Int) -> Void)?
    var itemStrings: [String]? {
        didSet {
            didSetItemString()
        }
    }

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
    }

    // MARK: - Actions
    private func didSetItemString() {
        var index = 0
        let buttonHeight: CGFloat = 25
        for item in itemStrings! {
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
            for v in subviews {
                if v.isKind(of: UIButton.self) {
                    let v = v as! UIButton
                    v.setTitleColor(.white, for: .normal)
                }
            }
            button.setTitleColor(.pinkColor, for: .normal)
        }
    }
}
