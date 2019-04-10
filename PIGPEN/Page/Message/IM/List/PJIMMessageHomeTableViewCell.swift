//
//  PJIMMessageHomeTableViewCell.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/10.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJIMMessageHomeTableViewCell: UITableViewCell {
    @IBOutlet weak private var avatarImaegView: UIImageView!
    @IBOutlet weak private var nickNameLabel: UILabel!
    @IBOutlet weak private var messageLabel: UILabel!
    @IBOutlet weak private var timeLabel: UILabel!
    @IBOutlet weak private var sendStatusImageView: UIImageView!
    
    
    func setModel(_ viewModel: ViewModel) {
        avatarImaegView.image = UIImage(named: "\(viewModel.avatar)")
        nickNameLabel.text = viewModel.nickName
        messageLabel.text = viewModel.message
        
        let date = Date(timeIntervalSince1970: TimeInterval(viewModel.time)!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        timeLabel.text = dateFormatter.string(from: date)
        
//        let contentSize = timeLabel.text!.size(with: UIFont.systemFont(ofSize: 12))
        
        
        
        if viewModel.sendStatus == .SentStatus_SENT {
            sendStatusImageView.isHidden = true
        } else {
            sendStatusImageView.isHidden = false
        }
    }
}

extension PJIMMessageHomeTableViewCell {
    struct ViewModel {
        var avatar: Int
        var nickName: String
        var message: String
        var time: String
        var sendStatus: RCSentStatus
    }
}
