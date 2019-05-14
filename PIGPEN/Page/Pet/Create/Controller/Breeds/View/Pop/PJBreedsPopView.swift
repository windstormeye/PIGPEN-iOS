//
//  PJBreedsPopView.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/5/14.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJBreedsPopView: UIView {

    @IBOutlet private weak var tipsLabel: UILabel!
    
    class func newInstance() -> PJBreedsPopView {
        return Bundle.main.loadNibNamed("PJBreedsPopView",
                                               owner: self,
                                               options: nil)!.first as! PJBreedsPopView
    }
    
    func setTitle(_ text: String) {
        tipsLabel.text = " " + text
    }
}
