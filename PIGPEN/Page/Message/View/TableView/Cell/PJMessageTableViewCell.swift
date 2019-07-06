//
//  PJMessageTableViewCell.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/5.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJMessageTableViewCell: UITableViewCell {

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nicknameLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var moreButton: UIButton!
    @IBOutlet private weak var contentImageView: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var likeNumberLabel: UILabel!
    @IBOutlet private weak var collectButton: UIButton!
    
    var viewModel = PIGBlog.BlogContent() {
        didSet {
            avatarImageView.kf.setImage(with: URL(string: viewModel.pet.avatar_url))
            contentImageView.kf.setImage(with: URL(string: viewModel.blog.imgs))
            nicknameLabel.text = viewModel.pet.nick_name
            timeLabel.text = convertTimestampToDateString3(viewModel.blog.createdTime)
            likeNumberLabel.text = String(viewModel.blog.likeCount)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        avatarImageView.layer.cornerRadius = avatarImageView.pj_height / 2
    }

    private func initView() {
        
    }
    
    @IBAction func moreAction(_ sender: Any) {
    }
}
