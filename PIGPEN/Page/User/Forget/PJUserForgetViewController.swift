//
//  PJUserForgetViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/26.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJUserForgetViewController: UIViewController {

    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var authCodeTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBOutlet weak var errorAuthCodeLabel: UILabel!
    @IBOutlet weak var errorPasswordLabel: UILabel!
    
    @IBOutlet weak var commitButton: UIButton!
    @IBOutlet weak var authCodeButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
