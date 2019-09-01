//
//  PJUserCenterPetTableViewCell.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/5/12.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJUserCenterPetTableViewCell: UITableViewCell {
    
    var clickType: ClickType = .none {
        didSet {
            
        }
    }
    var pet = PJPet.Pet() {
        didSet {
            avatarImageView.kf.setImage(with: URL(string: pet.avatar_url))
            titleLabel.text = pet.nick_name
            if pet.gender == 0 {
                genderImageView.image = UIImage(named: "gender_female")
            } else {
                genderImageView.image = UIImage(named: "gender_male")
            }
        }
    }
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var editButton: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.cornerRadius = avatarImageView.pj_height / 2
    }
    
    private func updateUI() {
        // TODO： 写界面显示隐藏的b逻辑
        switch clickType {
        case .small: break
        case .big: break
        case .none: break
        }
    }
}

extension PJUserCenterPetTableViewCell {
    enum ClickType {
        /// 缩小
        case small
        /// 放大
        case big
        /// 没动过
        case none
    }
}
