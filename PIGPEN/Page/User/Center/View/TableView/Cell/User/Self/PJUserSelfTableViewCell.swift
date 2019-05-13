//
//  PJUserSelfTableViewCell.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/4.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJUserSelfTableViewCell: UITableViewCell {
    // MARK: - Private Properties
    // 头像
    @IBOutlet weak private var avatarImageView: UIImageView!
    // 性别
    @IBOutlet weak private var genderImageView: UIImageView!
    // 饲养状态
    @IBOutlet weak private var statusLabel: UILabel!
    // 评分
    @IBOutlet weak private var levelLabel: UILabel!
    // 关注
    @IBOutlet weak private var followLabel: UILabel!
    // 收藏
    @IBOutlet weak private var starLabel: UILabel!
    /// 查看评分 Button
    @IBOutlet weak var levelButton: UIButton!
    /// 关注 Button
    @IBOutlet weak var followButton: UIButton!
    /// 收藏 Button
    @IBOutlet weak var starButton: UIButton!
    
    // MARK: - Public Properties
    var model: PJUser.UserModel? { didSet { didSetModel() } }
    var viewDelegate: PJUserSelfTableViewCellDelegate?

    // MARK: - Private Methods
    private func didSetModel() {
        avatarImageView.image = UIImage(named: String(model?.avatar ?? 0))
        genderImageView.image = UIImage(named: "user_info_gender_\(String(model?.gender ?? 0))")
    
//        var feedingStatusString = ""
//        if model?.feeding_status![0] == 1 {
//            feedingStatusString.append("猫 &")
//        }
//        if model?.feeding_status![1] == 1 {
//            feedingStatusString.append("狗 &")
//        }
//        if model?.feeding_status![2] == 1 {
//            feedingStatusString.append("虚拟狗 &")
//        }
//        if feedingStatusString == "" {
//            feedingStatusString = "暂无宠物"
//        } else {
//            feedingStatusString.removeLast()
//            feedingStatusString.removeLast()
//        }
//        statusLabel.text = feedingStatusString
//        
//        if model?.level == -1.0 {
//            levelLabel.text = "暂无评分"
//        } else {
//            levelLabel.text = String(model?.level ?? 0)
//        }
//
//        followLabel.text = String(model?.follow ?? 0)
//        starLabel.text = String(model?.star ?? 0)
    }
    
    @IBAction func levelButtonTapped(_ sender: UIButton) {
        viewDelegate?.PJUserSelfLevelButtonTapped()
    }
    
    @IBAction func followButtonTapped(_ sender: UIButton) {
        viewDelegate?.PJUserSelfFollowButtonTapped()
    }
    
    @IBAction func starButtonTapped(_ sender: UIButton) {
        viewDelegate?.PJUserSelftStarButtonTapped()
    }
}

// MARK: Protocol
protocol PJUserSelfTableViewCellDelegate: class  {
    func PJUserSelfLevelButtonTapped()
    func PJUserSelfFollowButtonTapped()
    func PJUserSelftStarButtonTapped()
}
extension PJUserSelfTableViewCell {
    func PJUserSelfLevelButtonTapped() {}
    func PJUserSelfFollowButtonTapped() {}
    func PJUserSelftStarButtonTapped() {}
}


