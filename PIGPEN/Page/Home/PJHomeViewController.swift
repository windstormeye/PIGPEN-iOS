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
        
        view.backgroundColor = .white
    
        let v = PJPetAboutScoreView.newInstance()
        v.top = 200
        v.centerX = view.centerX
        v.pj_width = view.pj_width - 30
        v.pj_height = 102
        
        var viewModel = PJPetAboutScoreView.ViewModel()
        viewModel.score = 5.2
        
        v.viewModel = viewModel
        view.addSubview(v)
        
        if PJUser.shared.userModel.token == nil {
            let navVC = UINavigationController(rootViewController: PJWelcomeViewController())
            present(navVC, animated: true, completion: nil)
        }
    }

}
