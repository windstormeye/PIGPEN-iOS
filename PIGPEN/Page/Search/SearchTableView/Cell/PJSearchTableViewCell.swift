//
//  PJSearchTableViewCell.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/14.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJSearchTableViewCell: UITableViewCell {
    var likeButtonClick: (() -> Void)?
    var chatButtonClick: (() -> Void)?
    
    var viewModel: PJUser.UserModel? {
        didSet { didSetViewModel() }
    }
    
    @IBOutlet weak private var avatarImageView: UIImageView!
    @IBOutlet weak private var nickNameLabel: UILabel!
    @IBOutlet weak private var accessImageView: UIImageView!
    @IBOutlet weak private var rightButton: UIButton!
    
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

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    private func didSetViewModel() {
        switch cellType {
        case .pet:
            accessImageView.isHidden = true
        case .user:
            accessImageView.isHidden = false
            rightButton.setImage(UIImage(named: "search_send"),
                                 for: .normal)
            avatarImageView.image = UIImage(named: String(viewModel!.avatar!))
            nickNameLabel.text = viewModel!.nick_name!
            
        }
    }
    
    @IBAction func rightButtonClick(_ sender: Any) {
        switch cellType {
        case .pet:
            likeButtonClick?()
        case .user:
            chatButtonClick?()
        }
    }
    
}

extension PJSearchTableViewCell {
    enum CellType {
        case pet
        case user
    }
}
