//
//  PJUserInfoViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/27.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit


fileprivate extension Selector {
    static let back = #selector(PJUserInfoViewController.back)
    static let avatar = #selector(PJUserInfoViewController.avatarImageViewTapped)
}

class PJUserInfoViewController: PJBaseViewController, PJUserInfoSeleteAvatarViewDelegate {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nickNamegTextField: UITextField!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var manButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var tipsLabel: UILabel!
    
    var userRegisterModel: PJUser.UserRegisterModel?
    
    // 默认为 -1
    private var avatarTag = -1
    // 默认为女性
    private var gendertag = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    
    private func initView() {
        title = "用户资料"
        backButtonTapped(backSel: .back)
        
        let avatarTapped = UITapGestureRecognizer(target: self, action: .avatar)
        avatarImageView.addGestureRecognizer(avatarTapped)
        // 默认为女性
        femaleButton.isSelected = true
    }
    
    
    // MARK: Action
    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc fileprivate func avatarImageViewTapped() {
        avatarSelectView.isHidden = false
    }
    
    
    @IBAction func okButtonTapped(_ sender: Any) {
        guard avatarTag != -1 && nickNamegTextField.text?.count != 0 else {
            return
        }
        var userRegisterModel = self.userRegisterModel
        userRegisterModel!.avatar = avatarTag
        userRegisterModel!.gender = gendertag
        userRegisterModel!.nickName = nickNamegTextField.text!
        
        PJHUD.shared.showLoading(view: view)
        PJUser.shared.register(registerModel: userRegisterModel!,
                               completeHandler: {
                                PJHUD.shared.dismiss()
                                PJTapic.succee()
                                NotificationCenter.default.post(name: .loginSuccess(),
                                                                object: nil)
        }) { (error) in
            PJTapic.error()
            PJHUD.shared.showError(view: self.view, text: error.errorMsg!)
        }
    }
    
    
    @IBAction func femaleButtonTapped(_ sender: UIButton) {
        gendertag = 1
        sender.isSelected = true
        manButton.isSelected = false
    }
    
    
    @IBAction func maleButtonTapped(_ sender: UIButton) {
        gendertag = 0
        sender.isSelected = true
        femaleButton.isSelected = false
    }
    
    
    // MARK: delegate
    func PJUserInfoSeleteAvatarViewCloseButtonTapped() {
        avatarSelectView.isHidden = true
    }
    
    
    func PJUserInfoSeleteAvatarViewAvatarTag(tag: Int) {
        avatarTag = tag
        avatarImageView.image = UIImage(named: String(tag))
    }
    
    
    func PJUserInfoSeleteAvatarViewTapped() {
        avatarSelectView.isHidden = true
    }
    
    
    // MARK: laze load
    lazy var avatarSelectView: PJUserInfoSeleteAvatarView = {
        let selectViewRect = CGRect(x: 0, y: headerView!.bottom,
                                    width: view.width,
                                    height: view.height)
        let selectedView = PJUserInfoSeleteAvatarView(frame: selectViewRect)
        selectedView.viewDelegate = self
        view.addSubview(selectedView)
        selectedView.isHidden = true
        return selectedView
    }()
}
