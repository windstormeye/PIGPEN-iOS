//
//  PJUserCreateVirtualPetChoiceNameViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/12.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let back = #selector(PJUserCreateVirtualPetChoiceNameViewController.back)
}

class PJUserCreateVirtualPetChoiceNameViewController: PJBaseViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var okButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    private func initView() {
        navigationItem.title = "请选择iDOG名字"
        backButtonTapped(backSel: .back)
        isHiddenBarBottomLineView = false
        
        okButton.backgroundColor = UIColor.unFocusColor()
    }

    // MARK: Action
    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func okButtonTapped(_ sender: UIButton) {
        
    }
    
}
