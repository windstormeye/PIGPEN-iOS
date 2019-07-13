//
//  PIGAroundPetCollectionViewCell.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/13.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PIGAroundPetCollectionViewCell: UICollectionViewCell {

    var viewModel = PJPet.Around() {
        didSet {
            if viewModel.distance > 10 {
                distanceLabel.text = "~"
            } else {
                distanceLabel.text = "\(viewModel.distance)"
            }
            avatarImageView.kf.setImage(with: URL(string: viewModel.pet.avatar_url))
        }
    }
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initView()
    }
    
    private func initView() {
        distanceLabel.layer.cornerRadius = distanceLabel.pj_height / 2
        distanceLabel.layer.masksToBounds = true
    }
}
