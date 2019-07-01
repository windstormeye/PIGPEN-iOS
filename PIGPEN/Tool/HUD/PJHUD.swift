//
//  PJHUD.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/20.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import JGProgressHUD

class PJHUD {
    static let shared = PJHUD()
    private var hud = JGProgressHUD(style: .dark)
    
    
    func show(view: UIView, text: String) {
        DispatchQueue.main.async {
            self.hud.textLabel.text = text
            self.hud.show(in: view)
            self.hud.dismiss(afterDelay: 2)
        }
    }
    
    func dismiss() {
        DispatchQueue.main.async {
            self.hud.dismiss()
        }
    }
    
    func showLoading(view: UIView) {
        DispatchQueue.main.async {
            self.hud.show(in: view)
        }
    }
    
    func showError(view: UIView, text: String) {
        DispatchQueue.main.async {
            self.hud.textLabel.text = text
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: view)
            self.hud.dismiss(afterDelay: 2)
        }
    }
}
