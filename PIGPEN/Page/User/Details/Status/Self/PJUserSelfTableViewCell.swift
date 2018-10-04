//
//  PJUserSelfTableViewCell.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/4.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJUserSelfTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var followLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    
    var model: PJUserDetailsModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateUI(model: PJUserDetailsModel) {
        avatarImageView.image = UIImage(named: String(model.avatar))
        
    }
    
}
