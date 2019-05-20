//
//  PJPetCreateAvatarViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/5/13.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit
import YPImagePicker


class PJPetCreateAvatarViewController: UIViewController, PJBaseViewControllerDelegate {
    var pet = PJPet.Pet()
    
    @IBOutlet weak var tipsTitleLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var femaleButton: UIButton!
    @IBOutlet private weak var maleButton: UIButton!
    @IBOutlet private weak var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBaseView()
        backButtonTapped(backSel: .back, imageName: nil)
        
        maleButton.addTarget(self, action: .changeButtonState, for: .touchUpInside)
        femaleButton.addTarget(self, action: .changeButtonState, for: .touchUpInside)
        doneButton.addTarget(self, action: .done, for: .touchUpInside)
        
        let avatarTapGesture = UITapGestureRecognizer(target: self, action: .avatarTap)
        avatarImageView.addGestureRecognizer(avatarTapGesture)
        avatarImageView.layer.cornerRadius = avatarImageView.pj_height / 2
        
        switch pet.pet_type {
        case .cat:
            tipsTitleLabel.text = "请选择猫咪头像"
            titleString = "添加猫咪"
            avatarImageView.image = UIImage(named: "pet_avatar_cat")
            genderLabel.text = "请选择猫咪性别"
        case .dog:
            tipsTitleLabel.text = "请选择狗狗头像"
            titleString = "添加狗狗"
        }
        
        doneButton.defualtStyle(nil)
    }

}

private extension Selector {
    static let back = #selector(PJPetCreateAvatarViewController.back)
    static let changeButtonState = #selector(PJPetCreateAvatarViewController.changeButtonState(button:))
    static let done = #selector(PJPetCreateAvatarViewController.done)
    static let avatarTap = #selector(PJPetCreateAvatarViewController.avatarTap)
}

extension PJPetCreateAvatarViewController {
    @objc
    fileprivate func back() {
        popBack()
    }
    
    @objc
    fileprivate func changeButtonState(button: UIButton) {
        femaleButton.isSelected = !femaleButton.isSelected
        maleButton.isSelected = !maleButton.isSelected
        
        if femaleButton.isSelected {
            pet.gender = 0
        } else {
            pet.gender = 1
        }
    }
    
    @objc
    fileprivate func done() {
        print(pet)
        
        let vc = UIStoryboard(name: "PJCreatePetDetailsViewController", bundle: nil).instantiateViewController(withIdentifier: "PJCreatePetDetailsViewController") as! PJCreatePetDetailsViewController
        vc.pet = pet
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    fileprivate func avatarTap() {
        let picker = YPImagePicker(configuration: pj_YPImagePicker())
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.avatarImageView.image = photo.image
                
                PJHUD.shared.showLoading(view: self.view)
                PJImageUploader.upload(assets: [photo.asset!],
                                       complateHandler: { [weak self] imgUrls,keys in
                                        guard let `self` = self else { return }
                                        self.pet.avatar_url = keys[0]
                                        
                                        PJHUD.shared.dismiss()
                }) { (error) in
                    PJHUD.shared.showError(view: self.view, text: error.errorMsg)
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
}
