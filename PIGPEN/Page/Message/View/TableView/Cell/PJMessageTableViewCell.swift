//
//  PJMessageTableViewCell.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/5.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJMessageTableViewCell: UITableViewCell {

    var likeSelected: ((Bool) -> Void)?
    var collectSelected: ((Bool) -> Void)?
    var moreSelected: (() -> Void)?
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nicknameLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var moreButton: UIButton!
    @IBOutlet private weak var contentImageView: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var likeNumberLabel: UILabel!
    @IBOutlet private weak var collectButton: UIButton!
    @IBOutlet private weak var bottomLineView: UIView!
    
    var viewModel = PIGBlog.BlogContent() {
        didSet {
            likeButton.isSelected = (viewModel.blog.isLike != 0)
            collectButton.isSelected = (viewModel.blog.isCollect != 0)
            
            avatarImageView.kf.setImage(with: URL(string: viewModel.pet.avatar_url))
            contentImageView.kf.setImage(with: URL(string: viewModel.blog.imgs))
            nicknameLabel.text = viewModel.pet.nick_name
            timeLabel.text = convertTimestampToDateString3(viewModel.blog.createdTime)
            likeNumberLabel.text = String(viewModel.blog.likeCount)
        }
    }
    
    class func newInstance() -> PJMessageTableViewCell {
        return Bundle.main.loadNibNamed("PJMessageTableViewCell",
                                        owner: self,
                                        options: nil)?.first! as! PJMessageTableViewCell
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        avatarImageView.layer.cornerRadius = avatarImageView.pj_height / 2
    }
    
    func isHiddenBottomLineView(_ isHidded: Bool) {
        bottomLineView.isHidden = isHidden
    }

    private func initView() {
        
    }
    
    @IBAction func moreAction(_ sender: Any) {
        
    }
    
    @IBAction func likeAction(_ sender: Any) {
        likeButton.isSelected = !likeButton.isSelected
        likeSelected?(likeButton.isSelected)
    }
    
    @IBAction func collectAction(_ sender: Any) {
        collectButton.isSelected = !collectButton.isSelected
        collectSelected?(collectButton.isSelected)
    }
}
