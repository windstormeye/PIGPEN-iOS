//
//  PJUserCenterPetTableViewCell.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/5/12.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJUserCenterPetTableViewCell: UITableViewCell {

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
}
