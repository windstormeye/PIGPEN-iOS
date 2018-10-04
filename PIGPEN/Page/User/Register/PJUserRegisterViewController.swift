//
//  PJUserRegisterViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/29.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit
import Schedule

fileprivate extension Selector {
    static let back = #selector(PJUserRegisterViewController.back)
    static let textFieldTextChange = #selector(PJUserRegisterViewController.textFieldTextChange(notification:))

}

class PJUserRegisterViewController: PJBaseViewController {
    @IBOutlet weak var authCodeTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var authCodeButton: UIButton!
    @IBOutlet weak var commitButton: UIButton!
    @IBOutlet weak var errorAuthCodeLabel: UILabel!
    
    var authCodeButtonTimes = 120
    
    private var plan: Task?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    
    private func initView() {
        title = "注册"
        backButtonTapped(backSel: .back)
        
        authCodeButton.layer.borderWidth = 1
        authCodeButton.layer.borderColor = PJRGB(r: 102, g: 102, b: 102).cgColor
        
        commitButton.backgroundColor = .unFocusColor()
        commitButton.isEnabled = false
        
        NotificationCenter.default.addObserver(self,
                                               selector: .textFieldTextChange,
                                               name: UITextField.textDidChangeNotification,
                                               object: nil)
    }
    
    // MARK: UI
    private func authCodeButtonSending() {
        authCodeButton.isEnabled = false
        plan = Schedule.every(1.second).do {
            self.authCodeButtonTimes -= 1
            let timesString = String(self.authCodeButtonTimes) + "s之后再次获取"
            DispatchQueue.main.async {
                if self.authCodeButtonTimes == 0 {
                    self.resetAuthCodeButton(timesString)
                } else {
                    self.authCodeButton.setTitle(timesString,
                                                 for: .normal)
                }
            }
        }
    }
    
    private func resetAuthCodeButton(_ timeString: String) {
        authCodeButton.isEnabled = true
        authCodeButtonTimes = 120
        authCodeButton.setTitle("获取验证码", for: .normal)
        plan?.cancel()
    }
    
    // MARK: Action
    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func authCodeButtonTapped(_ sender: UIButton) {
        guard phoneTextField.text?.count != 0 else {
            return
        }
        guard isPhoneNumber(phoneString: phoneTextField.text!) else {
            PJTapic.error()
            return
        }
        
        authCodeButtonSending()
        
        let phoneString = phoneTextField.text!
        SMSSDK.getVerificationCode(by: .SMS,
                                   phoneNumber: phoneString,
                                   zone: "86",
                                   template: "") { (error) in
                                    if error != nil {
                                        print(error!.localizedDescription)
                                    }
        }
    }
    
    @IBAction func okButtonTapped(_ sender: UIButton) {
        guard phoneTextField.text?.count != 0 &&
            authCodeTextField.text?.count != 0 &&
            passwordTextField.text?.count != 0 else {
                return
        }
        
        let phoneString = phoneTextField.text!
        let authCodeString = authCodeTextField.text!
        let passwordString = passwordTextField.text!
        SMSSDK.commitVerificationCode(authCodeString,
                                      phoneNumber: phoneString,
                                      zone: "86") { (error) in
                                        if error != nil {
                                            PJTapic.error()
                                            print(error!.localizedDescription)
                                        } else {
                                            let registerModel = PJUserRegisterModel(nickName: "",
                                                                                    phone: phoneString,
                                                                                    passwd: passwordString,
                                                                                    gender: 1,
                                                                                    avatar: -1)
                                            let vc = PJUserInfoViewController()
                                            vc.userRegisterModel = registerModel
                                            self.navigationController?.pushViewController(vc,
                                                                                          animated: true)
                                        }
        }
    }
    
    // MARK: Notification
    @objc func textFieldTextChange(notification: Notification) {
        if phoneTextField.text?.count != 0 &&
            passwordTextField.text?.count != 0 &&
            authCodeTextField.text?.count != 0 {
            commitButton.backgroundColor = .focusColor()
            commitButton.isEnabled = true
        } else {
            commitButton.backgroundColor = .unFocusColor()
            commitButton.isEnabled = false
        }
    }
}

