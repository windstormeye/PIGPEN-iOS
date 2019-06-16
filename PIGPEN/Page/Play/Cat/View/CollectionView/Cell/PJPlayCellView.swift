//
//  PJPlayCellView.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/6/11.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJPlayCellView: UICollectionViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dotView: UIView!
    
    var viewModel = PJPet.Pet() {
        didSet {
            updateData()
        }
    }
    
    override var isSelected: Bool  {
        didSet {
            dotView.isHidden = !isSelected
            
            if isSelected {
                backgroundColor = PJRGB(255, 248, 245)
            } else {
                backgroundColor = PJRGB(240, 240, 240)
            }
        }
    }
    
    class func newInstance() -> PJPlayCellView {
        return Bundle.main.loadNibNamed("PJPlayCellView",
                                        owner: self,
                                        options: nil)?.first! as!PJPlayCellView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 14
        layer.masksToBounds = true
        backgroundColor = PJRGB(240, 240, 240)
        
        avatarImageView.layer.cornerRadius = avatarImageView.pj_width / 2
        
        dotView.layer.cornerRadius = dotView.pj_height / 2
        dotView.layer.borderColor = UIColor.white.cgColor
        dotView.layer.borderWidth = 2
    }
    
    private func updateData() {
        avatarImageView.kf.setImage(with: URL(string: viewModel.avatar_url))
        nicknameLabel.text = viewModel.nick_name
        
        let cellY = (pj_height - statusLabel.bottom - 28) / 2 + statusLabel.bottom
        let foodStatusView = PJPlayCellDrawView(frame: CGRect(x: 0, y: 0, width: 28, height: 28), imageName: "pet_food_logo", score: CGFloat(viewModel.score.food_s))
        let drinkStatusView = PJPlayCellDrawView(frame: CGRect(x: 0, y: 0, width: 28, height: 28), imageName: "pet_drink_logo", score: CGFloat(viewModel.score.water_s))
        let playStatusView = PJPlayCellDrawView(frame: CGRect(x: 0, y: 0, width: 28, height: 28), imageName: "pet_play_logo", score: CGFloat(viewModel.score.play_s))
        let happyStatusView = PJPlayCellDrawView(frame: CGRect(x: 0, y: 0, width: 28, height: 28), imageName: "pet_happy_logo", score: CGFloat(viewModel.score.happy_s))
        
        
        let hStack = UIStackView(arrangedSubviews: [foodStatusView, drinkStatusView, playStatusView, happyStatusView])
        hStack.frame = CGRect(x: 0, y: cellY, width: pj_width, height: 28)
        addSubview(hStack)
        hStack.axis = .horizontal
        hStack.distribution = .fillEqually
        hStack.alignment = .center
        hStack.sizeThatFits(CGSize(width: 28, height: 28))
    }
}
