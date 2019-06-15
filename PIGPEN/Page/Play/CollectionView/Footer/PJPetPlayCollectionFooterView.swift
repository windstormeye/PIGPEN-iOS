//
//  PJPetPlayCollectionFooterView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/14.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJPetPlayCollectionFooterView: UICollectionViewCell {

    var itemSelected: ((Int) -> Void)?
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var waterImageView: UIImageView!
    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var happyImageView: UIImageView!
    @IBOutlet weak var happyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        func generateTapped() -> UITapGestureRecognizer {
            return UITapGestureRecognizer(target: self, action: .tapped)
        }
        
        foodImageView.addGestureRecognizer(generateTapped())
        foodLabel.addGestureRecognizer(generateTapped())

        waterImageView.addGestureRecognizer(generateTapped())
        waterLabel.addGestureRecognizer(generateTapped())

        happyImageView.addGestureRecognizer(generateTapped())
        happyLabel.addGestureRecognizer(generateTapped())
    }
    
    /// 高亮所有功能
    func hightlight() {
        foodImageView.isTouchEnable(true)
        foodLabel.isTouchEnable(true)
        
        waterImageView.isTouchEnable(true)
        waterLabel.isTouchEnable(true)
        
        happyImageView.isTouchEnable(true)
        happyLabel.isTouchEnable(true)
    }
    
    /// 取消高亮所有功能
    func unHightlight() {
        foodImageView.isTouchEnable(false)
        foodLabel.isTouchEnable(false)
        
        waterImageView.isTouchEnable(false)
        waterLabel.isTouchEnable(false)
        
        happyImageView.isTouchEnable(false)
        happyLabel.isTouchEnable(false)
    }
    
    /// 选中猫和狗
    func catAndDog() {
        foodImageView.isTouchEnable(false)
        foodLabel.isTouchEnable(false)
        
        waterImageView.isTouchEnable(true)
        waterLabel.isTouchEnable(true)
        
        happyImageView.isTouchEnable(false)
        happyLabel.isTouchEnable(false)
    }
    
    /// 选中所有宠物
    func allPets() {
        foodImageView.isTouchEnable(false)
        foodLabel.isTouchEnable(false)
        
        waterImageView.isTouchEnable(true)
        waterLabel.isTouchEnable(true)
        
        happyImageView.isTouchEnable(false)
        happyLabel.isTouchEnable(false)
    }
    
    /// 选中所有狗
    func allDogs() {
        foodImageView.isTouchEnable(false)
        foodLabel.isTouchEnable(false)
        
        waterImageView.isTouchEnable(true)
        waterLabel.isTouchEnable(true)
        
        happyImageView.isTouchEnable(true)
        happyLabel.isTouchEnable(true)
    }
    
    func allCats() {
        hightlight()
    }
    
    func dog() {
        hightlight()
    }
    
    @objc
    fileprivate func viewTapped(tapped: UITapGestureRecognizer) {
        itemSelected?(tapped.view!.tag)
    }
}

private extension Selector {
    static let tapped = #selector(PJPetPlayCollectionFooterView.viewTapped(tapped:))
}

private extension UIImageView {
    
    func isTouchEnable(_ touch: Bool) {
        isHighlighted = touch
        isUserInteractionEnabled = true
    }
}

private extension UILabel {
    
    func isTouchEnable(_ touch: Bool) {
        isHighlighted = touch
        isUserInteractionEnabled = true
    }
}
