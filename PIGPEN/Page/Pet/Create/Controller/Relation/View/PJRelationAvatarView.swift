//
//  PJRelationAvatarView.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/5/15.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJRelationAvatarView: UIView {

    @IBOutlet private weak var avatarButton: UIButton!
    
    
    class func newInstance() -> PJRelationAvatarView {
        return Bundle.main.loadNibNamed("PJRelationAvatarView",
                                        owner: self,
                                        options: nil)!.first as! PJRelationAvatarView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarButton.topImageBottomTitle(titleTop: 20)
    }
    
    func isSelected(_ isS: Bool) {
        avatarButton.isSelected = isS
    }
    
    func update(_ title: String, _ index: Int) {
        avatarButton.setTitle(title, for: .normal)
        avatarButton.setImage(UIImage(named: "pet_relation_\(index)_selected"), for: .selected)
        avatarButton.setImage(UIImage(named: "pet_relation_\(index)"), for: .normal)
    }
}
