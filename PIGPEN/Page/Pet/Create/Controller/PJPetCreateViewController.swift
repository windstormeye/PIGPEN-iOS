//
//  PJPetCreateViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/9.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let back = #selector(PJPetCreateViewController.back)
}

class PJPetCreateViewController: PJBaseViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        navigationItem.title = "添加宠物资料"
        backButtonTapped(backSel: .back)
        isHiddenBarBottomLineView = false
    }

    // MARK: Action
    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }
}
