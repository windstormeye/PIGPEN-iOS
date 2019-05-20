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

class PJPetCreateDogFoodViewController: UIViewController, PJBaseViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        initBaseView()
        titleString = "每日进食量参考"
        backButtonTapped(backSel: .back, imageName: nil)
    }
    
    // MARK: - Actions
    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }
}
