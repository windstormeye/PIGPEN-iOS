//
//  PJInputSelectView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/5.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJInputSelectView: PJBaseAlertViewController {
    
    static let shared = PJInputSelectView()
    var complateHandler: ((Int) -> Void)?
    
    private var selectButtonView = PJInputSelectButtonView()
    private var backgroundView = UIView()
    
    class func showAlertSheet(complationHandler: @escaping (Int) -> Void) {
        let inputSelect = PJInputSelectView()
        
        inputSelect.initView()
        inputSelect.complateHandler = complationHandler
        inputSelect.show()
    }
    
    private func initView() {
        backgroundView = UIView(frame: view.frame)
        view.addSubview(backgroundView)
        backgroundView.alpha = 0
        backgroundView.isUserInteractionEnabled = true
        backgroundView.backgroundColor = PJRGB(220, 220, 220)
        
        let tap = UITapGestureRecognizer(target: self, action: .dismissView)
        backgroundView.addGestureRecognizer(tap)
        
        selectButtonView = PJInputSelectButtonView.newInstance()
        view.addSubview(selectButtonView)
        selectButtonView.frame = CGRect(x: 0, y: view.pj_height, width: 100, height: 110)
        selectButtonView.right = view.pj_width - 20
        selectButtonView.selected = {
            self.dismissView()
            self.complateHandler?($0)
        }
    }
    
    private func show() {
        showAlert()
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.backgroundView.alpha = 0.7
            self.selectButtonView.bottom = self.view.pj_height - 10 - bottomSafeAreaHeight
        }) { (finished) in
            
        }
    }
}

extension PJInputSelectView {
    @objc
    fileprivate func dismissView() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.backgroundView.alpha = 0
            self.selectButtonView.top = self.view.pj_height
        }) { (finished) in
            if finished {
                self.dismissAlert()
            }
        }
    }
}

fileprivate extension Selector {
    static let dismissView = #selector(PJInputSelectView.dismissView)
}
