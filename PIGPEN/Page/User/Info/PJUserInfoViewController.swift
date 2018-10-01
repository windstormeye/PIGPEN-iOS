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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    
    private func initView() {
        title = "用户资料"
        backButtonTapped(backSel: .back)
        
        let avatarTapped = UITapGestureRecognizer(target: self, action: .avatar)
        avatarImageView.addGestureRecognizer(avatarTapped)
    }
    
    
    // MARK: Action
    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func avatarImageViewTapped() {
        
        avatarSelectView.isHidden = false
    }
    
    @IBAction func okButtonTapped(_ sender: Any) {
        
    }
    
    
    // MARK: delegate
    func PJUserInfoSeleteAvatarViewCloseButtonTapped() {
        avatarSelectView.isHidden = true
    }
    
    
    func PJUserInfoSeleteAvatarViewAvatarTag(tag: Int) {
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
