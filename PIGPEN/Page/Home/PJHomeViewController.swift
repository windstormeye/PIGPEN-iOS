//
//  HomeViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/25.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJHomeViewController: PJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PJUser.shared.userModel?.token == "" {
            let navVC = UINavigationController(rootViewController: PJWelcomeViewController())
            present(navVC, animated: true, completion: nil)
        }
    }

}
