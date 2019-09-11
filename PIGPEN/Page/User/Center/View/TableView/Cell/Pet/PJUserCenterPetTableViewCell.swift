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
            genderImageView.image = pet.gender == 0 ? UIImage(named: "gender_female") : UIImage(named: "gender_male")
            infoGenderImageView.image = pet.gender == 0 ? UIImage(named: "gender_female") : UIImage(named: "gender_male")
            infoPPPImageView.image = UIImage(named: "gender_\(pet.love_status)")
            infoBreedLabel.text = pet.breed_type
            
            let ageTimestamp = Int(Date().timeIntervalSince1970) - pet.birth_time
            let monthTimestamp = 3600 * 24 * 30
            let ageMonth = ageTimestamp / monthTimestamp / 6
            let age = ageMonth / 2 + ageMonth % 2
            infoAgeLabel.text = "\(age)岁"
            
            infoWeightLabel.text = "\(pet.weight)kg"
            
            food_sLabel.text = "\(pet.score?.food_s ?? 0)"
            water_sLabel.text = "\(pet.score?.water_s ?? 0)"
            play_sLabel.text = "\(pet.score?.play_s ?? 0)"
            happy_sLabel.text = "\(pet.score?.happy_s ?? 0)"
            
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
    @IBOutlet weak var infoGenderImageView: UIImageView!
    @IBOutlet weak var infoPPPImageView: UIImageView!
    @IBOutlet weak var infoBreedLabel: UILabel!
    @IBOutlet weak var infoAgeLabel: UILabel!
    @IBOutlet weak var infoWeightLabel: UILabel!
    
    @IBOutlet weak var food_sLabel: UILabel!
    @IBOutlet weak var water_sLabel: UILabel!
    @IBOutlet weak var play_sLabel: UILabel!
    @IBOutlet weak var happy_sLabel: UILabel!
    
    
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
