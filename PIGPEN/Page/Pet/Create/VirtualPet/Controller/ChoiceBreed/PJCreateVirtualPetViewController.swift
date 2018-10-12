//
//  PJCreateVirtualPetViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/12.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let back = #selector(PJCreateVirtualPetViewController.back)
}

class PJCreateVirtualPetViewController: PJBaseViewController {

    @IBOutlet weak var frenchBulldogButton: UIButton!
    @IBOutlet weak var welshCorgiButton: UIButton!
    @IBOutlet weak var weimaRunnerButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        navigationItem.title = "请选择iDOG品种"
        backButtonTapped(backSel: .back)
        isHiddenBarBottomLineView = false
    }

    // MARK: Action
    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func okButtonTapped(_ sender: UIButton) {
        let vc = PJCreateVirtualPetChoiceGenderViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
