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
        
        okButton.isEnabled = false
        okButton.backgroundColor = .unFocusColor()
    }

    // MARK: Action
    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bullDogButton(_ sender: UIButton) {
        frenchBulldogButton.isSelected = !frenchBulldogButton.isSelected
        welshCorgiButton.isSelected = false
        weimaRunnerButton.isSelected = false
        
        okButton.isEnabled = true
        okButton.backgroundColor = .focusColor()
    }
    
    @IBAction func weishCorgiButton(_ sender: UIButton) {
        welshCorgiButton.isSelected = !welshCorgiButton.isSelected
        frenchBulldogButton.isSelected = false
        weimaRunnerButton.isSelected = false
        
        okButton.isEnabled = true
        okButton.backgroundColor = .focusColor()
    }
    
    @IBAction func weimaRunnerButton(_ sender: UIButton) {
        weimaRunnerButton.isSelected = !weimaRunnerButton.isSelected
        frenchBulldogButton.isSelected = false
        frenchBulldogButton.isSelected = false
        
        okButton.isEnabled = true
        okButton.backgroundColor = .focusColor()
    }
    
    
    @IBAction func okButtonTapped(_ sender: UIButton) {
        var tag = 0
        if frenchBulldogButton.isSelected {
            tag = 0
        } else if welshCorgiButton.isSelected {
            tag = 1
        } else if weimaRunnerButton.isSelected {
            tag = 2
        }
        let vc = PJCreateVirtualPetChoiceGenderViewController()
        let model = PJVirtualPet.VirtualPetModel(pet_id: nil, nick_name: "", gender: 1, breed: tag)
        vc.model = model
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
