//
//  PJUserForgetViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/26.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit


fileprivate extension Selector {
    static let back = #selector(PJUserForgetViewController.back)
}

class PJUserForgetViewController: PJBaseViewController {

    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var authCodeTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBOutlet weak var errorAuthCodeLabel: UILabel!
    @IBOutlet weak var errorPasswordLabel: UILabel!
    
    @IBOutlet weak var commitButton: UIButton!
    @IBOutlet weak var authCodeButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        title = "忘记密码"
        backButtonTapped(backSel: .back)
        
        authCodeButton.layer.borderWidth = 1
        authCodeButton.layer.borderColor = UIColor.black.cgColor
    }
    
    // MARK: Action
    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }
}
