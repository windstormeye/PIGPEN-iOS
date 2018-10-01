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
        self.title = "登入"
        headerView?.backgroundColor = .white
        backButtonTapped(backSel: .back)
    }
    
    
    // MARK: Action
    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }
}


fileprivate extension Selector {
    static let back = #selector(PJUserLoginViewController.back)
}
