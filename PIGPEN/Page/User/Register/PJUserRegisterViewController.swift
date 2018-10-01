//
//  PJUserRegisterViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/29.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit


fileprivate extension Selector {
    static let back = #selector(PJUserRegisterViewController.back)
}


class PJUserRegisterViewController: PJBaseViewController {

    
    @IBOutlet weak var authCodeTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var authCodeButton: UIButton!
    @IBOutlet weak var commitButton: UIButton!
    
    @IBOutlet weak var errorAuthCodeLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    
    private func initView() {
        title = "注册"
        backButtonTapped(backSel: .back)
        
        authCodeButton.layer.borderWidth = 1
        authCodeButton.layer.borderColor = PJRGB(r: 102, g: 102, b: 102).cgColor
    }
    
    
    // MARK: Action
    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func okButtonTapped(_ sender: UIButton) {
        navigationController?.pushViewController(PJUserInfoViewController(),
                                                 animated: true)
    }
}

