//
//  PJMessageInputViewController.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/5.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJMessageInputViewController: UIViewController, PJBaseViewControllerDelegate {
    
    private var pet = PJPet.Pet()
    private var selectedPetsString = ""
    
    private var avatarImage = UIImage()
    private var textView = UITextView()
    private var textViewTipLabel = UILabel()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(avatarImage: UIImage, pet: PJPet.Pet) {
        self.init(nibName: nil, bundle: nil)
        self.avatarImage = avatarImage
        self.pet = pet
        initView()
    }
    
    private func initView() {
        view.backgroundColor = .white
        
        initBaseView()
        titleString = "分享照片"
        backButtonTapped(backSel: .back, imageName: nil)
        rightBarButtonItem(imageName: "ok_0", rightSel: .ok)
        
        let avatarImageView = UIImageView(frame: CGRect(x: 15, y: navigationBarHeight + 10, width: 124, height: 124))
        view.addSubview(avatarImageView)
        avatarImageView.image = avatarImage
        avatarImageView.contentMode = .scaleToFill
        
        textView = UITextView(frame: CGRect(x: avatarImageView.right + 10, y: avatarImageView.top, width: view.pj_width - avatarImageView.right - 10, height: avatarImageView.pj_height))
        view.addSubview(textView)
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.becomeFirstResponder()
        textView.delegate = self
        textView.tintColor = .black
        
        textViewTipLabel = UILabel(frame: CGRect(x: 7, y: 7, width: 0, height: 15))
        textView.addSubview(textViewTipLabel)
        textViewTipLabel.font = UIFont.systemFont(ofSize: 14)
        textViewTipLabel.text = "请输入分享内容"
        textViewTipLabel.textColor = PJRGB(220, 220, 220)
        textViewTipLabel.sizeToFit()
        
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
        petSelectView.selected = {
            self.selectedPetsString = $0
        }
    }

}

extension PJMessageInputViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != "" {
            textViewTipLabel.isHidden = true
        } else {
            textViewTipLabel.isHidden = false
        }
    }
}

extension PJMessageInputViewController {
    @objc
    fileprivate func back() {
        popBack()
    }
    
    @objc
    fileprivate func ok() {
        // 这部分只有客户端做限制了 240 个字符，API 是长文本
        guard textView.text.count <= 240 else { return }
        
        var blog = PIGBlog.Blog()
        blog.content = textView.text
        blog.imgs = pet.avatar_url
        
        PJHUD.shared.showLoading(view: view)
        PIGBlog.create(blog: blog, petIds: selectedPetsString, complateHandler: {
            PJHUD.shared.dismiss()
            
            self.navigationController?.popViewController(animated: true)
        }) {
            print($0.errorMsg)
        }
    }
}

private extension Selector {
    static let back = #selector(PJMessageInputViewController.back)
    static let ok = #selector(PJMessageInputViewController.ok)
}
