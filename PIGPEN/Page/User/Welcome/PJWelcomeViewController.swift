//
//  PJWelcomeViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/1.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJWelcomeViewController: PJBaseViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var toHomeButton: UIButton!
    
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    
    private func initView() {
        isHiddenBarBottomLineView = true
        headerView?.isHidden = true
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        navigationController?.pushViewController(PJUserLoginViewController(),
                                                 animated: true)
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        navigationController?.pushViewController(PJUserRegisterViewController(),
                                                 animated: true)
    }
    
    @IBAction func toHomeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
