//
//  PJCreateRealPetViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/12.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let back = #selector(PJCreateRealPetViewController.back)
}

class PJCreateRealPetViewController: PJBaseViewController, UITextFieldDelegate {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    // tag = 1000
    @IBOutlet weak var breedTextField: UITextField!
    // tag = 1001
    @IBOutlet weak var birthTextField: UITextField!
    // tag = 1002
    @IBOutlet weak var weightTextField: UITextField!
    // tag = 1003
    @IBOutlet weak var pppTextField: UITextField!
    // tag = 1004
    @IBOutlet weak var loveTextField: UITextField!
    // tag = 1005
    @IBOutlet weak var relationshipTextField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        navigationItem.title = "添加宠物资料"
        backButtonTapped(backSel: .back)
        isHiddenBarBottomLineView = false
        
        okButton.backgroundColor = UIColor.unFocusColor()
        
        breedTextField.delegate = self
        pppTextField.delegate = self
        breedTextField.delegate = self
        breedTextField.delegate = self
        relationshipTextField.delegate = self
        weightTextField.delegate = self
        loveTextField.delegate = self
    }
    
    // MARK: Action
    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func femaleButtonTapped(_ sender: UIButton) {
        femaleButton.isSelected = !femaleButton.isSelected
        maleButton.isSelected = false
    }
    
    @IBAction func maleButtonTapped(_ sender: UIButton) {
        maleButton.isSelected = !maleButton.isSelected
        femaleButton.isSelected = false
    }
    
    @IBAction func okButtonTapped(_ sender: UIButton) {
        
    }
    
    // MARK: - Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard textField.tag >= 1000 else {
            return true
        }
        
        switch textField.tag {
        case 1000:
            navigationController?.pushViewController(PJBreedsViewController(),
                                                     animated: true)
        case 1001: break
        case 1002: break
        case 1003: break
        case 1004: break
        default: break
        }
        
        return false
    }
}
