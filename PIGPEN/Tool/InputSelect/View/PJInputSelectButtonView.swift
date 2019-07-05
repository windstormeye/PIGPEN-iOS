//
//  PJInputSelectButtonView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/5.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJInputSelectButtonView: UIView {

    var selected: ((Int) -> Void)?
    
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    class func newInstance() -> PJInputSelectButtonView {
        return Bundle.main.loadNibNamed("PJInputSelectButtonView",
                                        owner: self,
                                        options: nil)?.first! as! PJInputSelectButtonView
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
    @IBAction func albumAction(_ sender: Any) {
        selected?(0)
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        selected?(1)
    }
}
