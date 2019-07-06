//
//  PJMessageInputViewController.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/5.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJMessageInputViewController: UIViewController, PJBaseViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        view.backgroundColor = .white
        
        initBaseView()
        titleString = "娱乐圈"
        backButtonTapped(backSel: .back, imageName: nil)
        
        let avatarImageView = UIImageView(frame: CGRect(x: 15, y: navigationBarHeight + 10, width: 124, height: 124))
        view.addSubview(avatarImageView)
//        avatarImageView.kf.setImage(with: URL(string: pet.avatar_url))
        avatarImageView.image = UIImage(named: "message_pet")
        avatarImageView.contentMode = .scaleToFill
        
        let textView = UITextView(frame: CGRect(x: avatarImageView.right + 10, y: avatarImageView.top, width: view.pj_width - avatarImageView.right - 10, height: avatarImageView.pj_height))
        view.addSubview(textView)
        textView.becomeFirstResponder()
        
        let lineView = UIView(frame: CGRect(x: 15, y: avatarImageView.bottom + 10, width: view.pj_width - 30, height: 0.5))
        view.addSubview(lineView)
        lineView.backgroundColor = .backgrounGrayColor
        
        let tipLabel = UILabel(frame: CGRect(x: avatarImageView.left, y: lineView.bottom + 10, width: 0, height: 15))
        tipLabel.font = UIFont.systemFont(ofSize: 12)
        tipLabel.text = "请选择分享图片的宠物"
        view.addSubview(tipLabel)
        tipLabel.sizeToFit()
        
        let petSelectView = PJPetSelectView(frame: CGRect(x: 0, y: tipLabel.bottom + 10, width: view.pj_width, height: 26), pets: PJUser.shared.pets)
        view.addSubview(petSelectView)
    }

}

extension PJMessageInputViewController {
    @objc
    fileprivate func back() {
        popBack()
    }
}

private extension Selector {
    static let back = #selector(PJMessageInputViewController.back)
}
