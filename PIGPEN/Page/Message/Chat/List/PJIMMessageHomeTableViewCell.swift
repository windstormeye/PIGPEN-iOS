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
    
    @IBOutlet weak private var messageLabelWidthConstraints: NSLayoutConstraint!
    
    override func layoutSubviews() {
        selectionStyle = .none
        messageLabelWidthConstraints.constant = width - messageLabel.left - timeLabel.width - 50
    }
    
    func setModel(_ viewModel: ViewModel) {
        avatarImaegView.image = UIImage(named: "\(viewModel.avatar)")
        nickNameLabel.text = viewModel.nickName
        messageLabel.text = viewModel.message

        let timestamp = Double(viewModel.time)! / Double(1000)
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/ MM/dd HH:mm"
        timeLabel.text = dateFormatter.string(from: date)
        
        
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
