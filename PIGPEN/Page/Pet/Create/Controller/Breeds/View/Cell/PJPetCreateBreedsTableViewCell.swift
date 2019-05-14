//
//  PJPetCreateBreedsTableViewCell.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/5/14.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJPetCreateBreedsTableViewCell: UITableViewCell {

    @IBOutlet private weak var tipsTitleLabel: UILabel!
    @IBOutlet private(set) weak var tipsImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func isHiddenTipImageView(_ isHidden: Bool) {
        tipsImageView.isHidden = isHidden
    }
    
    func setTipsTitleText(_ text: String) {
        tipsTitleLabel.text = text
    }
}
