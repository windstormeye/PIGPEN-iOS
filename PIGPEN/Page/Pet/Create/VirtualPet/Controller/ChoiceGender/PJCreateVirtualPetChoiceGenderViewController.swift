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
    @IBOutlet weak var okButton: UIButton!
    
    var model: PJVirtualPet.VirtualPetModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        navigationItem.title = "请选择iDOG性别"
        backButtonTapped(backSel: .back)
        isHiddenBarBottomLineView = false
        
        okButton.isEnabled = false
        okButton.backgroundColor = .unFocusColor
    }

    // MARK: Action
    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func femaleButton(_ sender: UIButton) {
        femaleButton.isSelected = !femaleButton.isSelected
        maleButton.isSelected = false
        
        okButton.isEnabled = true
        okButton.backgroundColor = .focusColor
    }
    
    @IBAction func maleButton(_ sender: UIButton) {
        maleButton.isSelected = !maleButton.isSelected
        femaleButton.isSelected = false
        
        okButton.isEnabled = true
        okButton.backgroundColor = .focusColor
    }
    
    @IBAction func okButton(_ sender: UIButton) {
        var tag = 0
        if femaleButton.isSelected {
            tag = 1
        } else {
            tag = 0
        }
        let vc = PJUserCreateVirtualPetChoiceNameViewController()
        model?.gender = tag
        vc.model = model!
        navigationController?.pushViewController(vc, animated: true)
    }
}
