//
//  PJBaseAlertViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/11/15.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJBaseAlertViewController: UIViewController {

    var pickerWindow: UIWindow?
    var mainWindow: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        mainWindow = windowFromLevel(level: .normal)
        pickerWindow = windowFromLevel(level: .alert)
        
        if pickerWindow == nil {
            pickerWindow = UIWindow(frame: UIScreen.main.bounds)
            pickerWindow?.windowLevel = .alert
            pickerWindow?.backgroundColor = .clear
        }
        pickerWindow?.rootViewController = self
        pickerWindow?.isUserInteractionEnabled = true
    }

    // show alert 必调方法
    func showAlert() {
        pickerWindow?.makeKeyAndVisible()
    }
    
    // dismiss alert 必调方法
    func dismissAlert() {
        pickerWindow?.isHidden = true
        pickerWindow?.removeFromSuperview()
        pickerWindow?.rootViewController = nil
        pickerWindow = nil
        mainWindow?.makeKeyAndVisible()
    }
    
}
