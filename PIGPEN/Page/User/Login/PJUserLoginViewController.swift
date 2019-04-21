//
//  PJUserLoginViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/26.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJUserLoginViewController: PJBaseViewController {
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwdTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    // MARK: life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    
    private func initView() {
        title = "登录"
        if currenVCFromPush(navc: navigationController, currenVC: self) {
            backButtonTapped(backSel: .back)
        } else {
            leftBarButtonItemTapped(leftTapped: .back, imageName: "close")
        }
        
        
        loginButton.backgroundColor = .unFocusColor
        loginButton.isEnabled = false
        
        NotificationCenter.default.addObserver(self,
                                               selector: .textFieldTextChange,
                                               name: UITextField.textDidChangeNotification,
                                               object: nil)
    }
    
    
    // MARK: Action
    @objc fileprivate func back() {
        dissmisCurrentVC(navc: navigationController ?? nil, currenVC: self)
    }
    
    @IBAction func forgetButtonTapped(_ sender: UIButton) {
        navigationController?.pushViewController(PJUserForgetViewController(),
                                                 animated: true)
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let phone = phoneTextField.text
        let passwd = passwdTextField.text
        PJHUD.shared.showLoading(view: view)
        PJUser.shared.login(phone: phone!, passwd: passwd!, completeHandler: {
            PJTapic.succee()
            PJHUD.shared.dismiss()
            DispatchQueue.main.async {
                dissmisCurrentVC(navc: self.navigationController, currenVC: self)
            }
            NotificationCenter.default.post(name: .loginSuccess(), object: nil)
        }) { (error) in
            PJHUD.shared.dismiss()
            PJTapic.error()
            print(error.errorMsg ?? "未知错误")
        }
    }
    
    
    // MARK: Notification
    @objc func textFieldTextChange(notification: Notification) {
        if phoneTextField.text?.count != 0 && passwdTextField.text?.count != 0 {
            loginButton.backgroundColor = .focusColor
            loginButton.isEnabled = true
        } else {
            loginButton.backgroundColor = .unFocusColor
            loginButton.isEnabled = false
        }
    }
    
}


fileprivate extension Selector {
    static let back = #selector(PJUserLoginViewController.back)
    static let textFieldTextChange = #selector(PJUserLoginViewController.textFieldTextChange(notification:))
}
