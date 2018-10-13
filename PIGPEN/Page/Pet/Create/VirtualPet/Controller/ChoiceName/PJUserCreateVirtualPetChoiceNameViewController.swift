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
    static let textFieldTextChange = #selector(PJUserCreateVirtualPetChoiceNameViewController.textFieldTextChange(notification:))
}

class PJUserCreateVirtualPetChoiceNameViewController: PJBaseViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var okButton: UIButton!
    
    var model: VirtualPetModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    private func initView() {
        navigationItem.title = "请选择iDOG名字"
        backButtonTapped(backSel: .back)
        isHiddenBarBottomLineView = false
        
        okButton.isEnabled = false
        okButton.backgroundColor = UIColor.unFocusColor()
        
        NotificationCenter.default.addObserver(self,
                                               selector: .textFieldTextChange,
                                               name: UITextField.textDidChangeNotification,
                                               object: nil)
    }

    // MARK: Action
    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func okButtonTapped(_ sender: UIButton) {
        model?.nick_name = nameTextField.text!
        
        PJVirtualPet.create(model: model!, complateHandler: {
            self.navigationController?.popToRootViewController(animated: true)
        }) { (error) in
            print(error)
        }
    }
    
    // MARK: Notification
    @objc func textFieldTextChange(notification: Notification) {
        if nameTextField.text?.count != 0 {
            okButton.backgroundColor = .focusColor()
            okButton.isEnabled = true
        } else {
            okButton.backgroundColor = .unFocusColor()
            okButton.isEnabled = false
        }
    }
}
