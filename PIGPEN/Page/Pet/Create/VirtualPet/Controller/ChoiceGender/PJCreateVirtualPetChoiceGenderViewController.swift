//
//  PJCreateVirtualPetChoiceGenderViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/12.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let back = #selector(PJCreateVirtualPetChoiceGenderViewController.back)
}

class PJCreateVirtualPetChoiceGenderViewController: PJBaseViewController {

    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        navigationItem.title = "请选择iDOG性别"
        backButtonTapped(backSel: .back)
        isHiddenBarBottomLineView = false
    }

    // MARK: Action
    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func okButton(_ sender: UIButton) {
        let vc = PJUserCreateVirtualPetChoiceNameViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
