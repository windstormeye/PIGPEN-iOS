//
//  PJDetailUserTableViewCell.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/15.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJDetailUserTableViewCell: UITableViewCell {

    var viewModel: ViewModel? {
        didSet { didSetViewModel() }
    }
    
    @IBOutlet private weak var avatarEditImageView: UIImageView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var firstButton: UIButton!
    @IBOutlet private weak var secondButton: UIButton!
    @IBOutlet private weak var threeButton: UIButton!
    @IBOutlet private weak var chatButton: UIButton!
    @IBOutlet private weak var genderImageView: UIImageView!
    @IBOutlet private weak var genderImageViewRightConstraint: NSLayoutConstraint!
    
    
    func isHiddenChatButton(_ isHidden: Bool) {
        chatButton.isHidden = isHidden
        genderImageViewRightConstraint.constant = 30
    }
    
    func isHiddenAvatarEditImageView(_ isHidden: Bool) {
        avatarEditImageView.isHidden = isHidden
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let avatarTap = UITapGestureRecognizer(target: self, action: .avatarTap)
        avatarImageView.addGestureRecognizer(avatarTap)
    }
    
    private func didSetViewModel() {
        avatarImageView.image = UIImage(named: "\(viewModel!.avatar)")
        
        firstButton.setTitle(viewModel!.firstTitle, for: .normal)
        let firstString = firstButton.title(for: .normal)!
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        
        let firstStringAttString = NSMutableAttributedString(string: firstString)
        firstStringAttString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: firstString.count))
        firstStringAttString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range:NSMakeRange(0, viewModel!.firstCount))
        firstButton.setAttributedTitle(firstStringAttString, for: .normal)
        firstButton.tintColor = .lightGray
        
        secondButton.setTitle(viewModel!.secondTitle, for: .normal)
        let moneyString = secondButton.title(for: .normal)!
        let moneyAttString = NSMutableAttributedString(string: moneyString)
        moneyAttString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], range:NSMakeRange(0, viewModel!.secondCount))
        moneyAttString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: moneyString.count))
        secondButton.setAttributedTitle(moneyAttString, for: .normal)
        secondButton.tintColor = .lightGray
        
        threeButton.setTitle(viewModel!.threeTitle, for: .normal)
        let levelString = threeButton.title(for: .normal)!
        let levelAttString = NSMutableAttributedString(string: levelString)
        levelAttString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], range:NSMakeRange(0, viewModel!.threeCount))
        levelAttString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: levelString.count))
        threeButton.setAttributedTitle(levelAttString, for: .normal)
        threeButton.tintColor = .lightGray
    }
}

extension PJDetailUserTableViewCell {
    @objc
    fileprivate func avatarTap() {
        
    }
}

private extension Selector {
    static let avatarTap = #selector(PJDetailUserTableViewCell.avatarTap)
}

extension PJDetailUserTableViewCell {
    struct ViewModel {
        var avatar: Int
        /// 第一个字符的数字个数
        var firstCount: Int
        var firstTitle: String
        /// 第二个字符的数字个数
        var secondCount: Int
        var secondTitle: String
        /// 第三个字符的s数字个数
        var threeCount: Int
        var threeTitle: String
    }
}
