//
//  PJUserLoginViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/26.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJUserLoginViewController: PJBaseViewController {

    
    // MARK: life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "登入"
        backButtonTapped(backSel: .back)
    }
    
    
    // MARK: Action
    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func forgetButtonTapped(_ sender: UIButton) {
        navigationController?.pushViewController(PJUserForgetViewController(),
                                                 animated: true)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
    }
}


fileprivate extension Selector {
    static let back = #selector(PJUserLoginViewController.back)
}
