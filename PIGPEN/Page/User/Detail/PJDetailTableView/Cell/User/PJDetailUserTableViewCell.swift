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
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var followsButton: UIButton!
    @IBOutlet weak var moneyButton: UIButton!
    @IBOutlet weak var levelButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    
    private func didSetViewModel() {
        avatarImageView.image = UIImage(named: "\(viewModel!.avatar)")
        
        followsButton.setTitle("\(viewModel!.follows)\n已关注", for: .normal)
        let followCountString = "\(viewModel!.follows)"
        let followString = followsButton.title(for: .normal)!
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        
        let followAttString = NSMutableAttributedString(string: followString)
        followAttString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: followString.count))
        followAttString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range:NSMakeRange(0, followCountString.count))
        followsButton.setAttributedTitle(followAttString, for: .normal)
        followsButton.tintColor = .lightGray
        
        moneyButton.setTitle("\(viewModel!.money)\n猪饲料", for: .normal)
        let moneyCountString = "\(viewModel!.money)"
        let moneyString = moneyButton.title(for: .normal)!
        let moneyAttString = NSMutableAttributedString(string: moneyString)
        moneyAttString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], range:NSMakeRange(0, moneyCountString.count))
        moneyAttString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: moneyString.count))
        moneyButton.setAttributedTitle(moneyAttString, for: .normal)
        moneyButton.tintColor = .lightGray
        
        levelButton.setTitle("\(viewModel!.level)\n评分", for: .normal)
        let levelCountString = "\(viewModel!.level)"
        let levelString = levelButton.title(for: .normal)!
        let levelAttString = NSMutableAttributedString(string: levelString)
        levelAttString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], range:NSMakeRange(0, levelCountString.count))
        levelAttString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: levelString.count))
        levelButton.setAttributedTitle(levelAttString, for: .normal)
        levelButton.tintColor = .lightGray
    }
}


extension PJDetailUserTableViewCell {
    struct ViewModel {
        var avatar: Int
        var follows: Int
        var money: Int
        var level: Float
    }
}
