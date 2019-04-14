//
//  PJSearchTableViewCell.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/14.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var accessImageView: UIImageView!
    @IBOutlet weak var rightButton: UIButton!
    
    var cellType = CellType.user
    var isLike: Bool? {
        didSet {
            guard cellType != .pet else { return }
            if isLike! {
                rightButton.setImage(UIImage(named: "search_pet_unlike"),
                                     for: .normal)
            } else {
                rightButton.setImage(UIImage(named: "search_pet_like"),
                                     for: .normal)
            }
        }
    }
    var viewModel: PJUser? {
        didSet { didSetViewModel() }
    }
    
    private func didSetViewModel() {
        switch cellType {
        case .pet:
            accessImageView.isHidden = true
        case .user:
            accessImageView.isHidden = false
            rightButton.setImage(UIImage(named: "search_send"),
                                 for: .normal)
            avatarImageView.image = UIImage(named: String(viewModel!.userModel.avatar!))
            nickNameLabel.text = viewModel!.userModel.nick_name!
            
        }
    }
}

extension PJSearchTableViewCell {
    enum CellType {
        case pet
        case user
    }
}
