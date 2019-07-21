//
//  PIGPetDetailInfoView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/21.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PIGPetDetailInfoView: UIView {

    class func newInstance() -> PIGPetDetailInfoView {
        return Bundle.main.loadNibNamed("PIGPetDetailInfoView",
                                        owner: self,
                                        options: nil)?.first! as! PIGPetDetailInfoView
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
