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
            nicknameLabel.text = pet.nick_name
            if pet.gender == 0 {
                genderImageView.image = UIImage(named: "gender_female")
            } else {
                genderImageView.image = UIImage(named: "gender_male")
            }
        }
    }
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var editButton: UIImageView!
    @IBOutlet weak var fensStackView: UIStackView!
    @IBOutlet weak var idStackView: UIStackView!
    @IBOutlet weak var fensLLabel: UILabel!
    
    @IBOutlet weak var avatarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var scoreStackView: UIStackView!
    @IBOutlet weak var scoreBgView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scoreBgView.layer.cornerRadius = scoreStackView.pj_height / 2
        scoreBgView.layer.masksToBounds = true
    }
    
    func updateUI(_ isClick: Bool) {
        if isClick {
            
        } else {
            
        }
        
        fensLLabel.isHidden = isClick
        genderImageView.isHidden = isClick
        
        fensStackView.isHidden = !isClick
        idStackView.isHidden = !isClick
        infoStackView.isHidden = !isClick
        scoreStackView.isHidden = !isClick
        scoreBgView.isHidden = !isClick
        
        let avatarWidth: CGFloat = isClick ? 58 : 36
        avatarHeightConstrain.constant = avatarWidth
        avatarWidthConstraint.constant = avatarWidth
        avatarImageView.layer.cornerRadius = avatarWidth / 2
    }
}
