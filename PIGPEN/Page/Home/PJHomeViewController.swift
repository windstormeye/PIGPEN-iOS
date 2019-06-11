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
        
        let bgImg = UIImageView(frame: CGRect(x: 0, y: 0, width: view.pj_width, height: view.pj_height))
        bgImg.image = UIImage(named: "home")
        view.addSubview(bgImg)
        
        if PJUser.shared.userModel.token == nil {
            let navVC = UINavigationController(rootViewController: PJWelcomeViewController())
            present(navVC, animated: true, completion: nil)
        }
    }

}
