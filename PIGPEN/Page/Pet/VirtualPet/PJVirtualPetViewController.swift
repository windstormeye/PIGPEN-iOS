//
//  PJVirtualPetViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/12.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let back = #selector(PJVirtualPetViewController.back)
}

class PJVirtualPetViewController: PJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        // 记得改掉
        navigationItem.title = "宠物详情"
        backButtonTapped(backSel: .back)
        isHiddenBarBottomLineView = false
    }
    
    // MARK: Action
    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }
    

}
