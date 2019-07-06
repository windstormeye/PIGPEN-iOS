//
//  PJPetSelectView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/6.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJPetSelectView: UIView {

    var selected: ((String) -> Void)?
    var pets = [PJPet.Pet]()
    
    private var selectedPets = [PJPet.Pet]()
    private var detailsView = [UIView]()
    private var scrollView = UIScrollView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, pets: [PJPet.Pet]) {
        self.init(frame: frame)
        self.pets = pets
        initView()
    }
    
    private func initView() {
        backgroundColor = .clear
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: pj_width, height: pj_height))
        addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        var previousRight: CGFloat = 0
        for (index, pet) in pets.enumerated() {
            let bgView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 26))
            bgView.isUserInteractionEnabled = true
            bgView.tag = index
            detailsView.append(bgView)
            scrollView.addSubview(bgView)
            
            let tap = UITapGestureRecognizer(target: self, action: .tap)
            bgView.addGestureRecognizer(tap)
            
            let avatarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
            bgView.addSubview(avatarImageView)
            avatarImageView.layer.cornerRadius = 13
            avatarImageView.layer.masksToBounds = true
            avatarImageView.contentMode = .scaleAspectFill
            avatarImageView.kf.setImage(with: URL(string: pet.avatar_url))
            avatarImageView.layer.cornerRadius = avatarImageView.pj_height / 2
            
            let nicknameLabel = UILabel(frame: CGRect(x: avatarImageView.right + 2, y: (pj_height - 16) / 2, width: 0, height: 16))
            bgView.addSubview(nicknameLabel)
            nicknameLabel.text = pet.nick_name
            nicknameLabel.font = UIFont.systemFont(ofSize: 14)
            nicknameLabel.textAlignment = .left
            nicknameLabel.sizeToFit()
            
            let tipsImageView = UIImageView(frame: CGRect(x: nicknameLabel.right + 2, y: (pj_height - 14) / 2, width: 14, height: 14))
            tipsImageView.tag = 1000
            tipsImageView.image = UIImage(named: "ok")?.withRenderingMode(.alwaysTemplate)
            tipsImageView.tintColor = PJRGB(220, 220, 220)
            bgView.addSubview(tipsImageView)
            
            bgView.left = previousRight + 10
            bgView.pj_width = tipsImageView.right
            
            previousRight = bgView.right
        }
        
        scrollView.contentSize = CGSize(width: previousRight + 10, height: 0)
    }

}


extension PJPetSelectView {
    @objc
    fileprivate func tap(tap: UITapGestureRecognizer) {
        let tapPoint = tap.location(in: scrollView)
        
        let targetView = detailsView.filter {
            return $0.layer.contains($0.layer.convert(tapPoint, from: self.scrollView.layer))
        }
        
        let currentIndex = targetView.first!.tag
        let tipsImageView = targetView.first!.subviews.filter({
            return $0.tag == 1000
        })
        
        let tips = tipsImageView.first! as! UIImageView
        if tips.tintColor == PJRGB(220, 220, 220) {
            tips.tintColor = .selectedPinkColor
            PJTapic.select()
            
            selectedPets.append(pets[currentIndex])

        } else {
            tips.tintColor = PJRGB(220, 220, 220)
            
            selectedPets.removeAll {
                return $0.pet_id == self.pets[currentIndex].pet_id
            }
        }
        
        var petIds = ""
        for pet in selectedPets {
            petIds += "\(pet.pet_id),"
        }
        
        selected?(petIds)
        print(petIds)
    }
}

private extension Selector {
    static let tap = #selector(PJPetSelectView.tap(tap:))
}
