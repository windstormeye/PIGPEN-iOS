//
//  PJFriendTableViewCell.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/26.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJFriendTableViewCell: UITableViewCell {
    var chatButtonClick: (() -> Void)?
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var chatButton: UIButton!
    
    var viewModel: PJUser.FriendModel? {
        didSet { didSetViewModel() }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func didSetViewModel() {
    }
}
