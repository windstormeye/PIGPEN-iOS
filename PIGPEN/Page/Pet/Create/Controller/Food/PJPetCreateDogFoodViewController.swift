//
//  PJDogFoodViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/11/15.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let back = #selector(PJPetCreateDogFoodViewController.back)
}

class PJPetCreateDogFoodViewController: PJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        title = "每日进食量参考"
        backButtonTapped(backSel: .back)
    }
    
    // MARK: - Actions
    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }
}
