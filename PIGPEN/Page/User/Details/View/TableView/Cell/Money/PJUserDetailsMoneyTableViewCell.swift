//
//  PJUserDetailsMoneyTableViewCell.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/12.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

protocol PJUserDetailsMoneyTableViewCellDelegate {
    func PJUserDetailsMoneyTableViewCellLookButtonTapped()
    func PJUserDetailsMoneyTableViewCellStealButtonTapped()
}

extension PJUserDetailsMoneyTableViewCellDelegate {
    func PJUserDetailsMoneyTableViewCellLookButtonTapped() {}
    func PJUserDetailsMoneyTableViewCellStealButtonTapped() {}
}

class PJUserDetailsMoneyTableViewCell: UITableViewCell {

    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var lookButton: UIButton!
    @IBOutlet weak var stealButton: UIButton!
    
    var viewDelegate: PJUserDetailsMoneyTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()	    
    }

    private func initView() {
        backgroundColor = .white
        selectionStyle = .none
        
        lookButton.layer.cornerRadius = 20
        lookButton.layer.borderWidth = 1
        lookButton.layer.borderColor = UIColor.black.cgColor
        
    }
    
    @IBAction func lookButtonTapped(_ sender: UIButton) {
        viewDelegate?.PJUserDetailsMoneyTableViewCellLookButtonTapped()
    }
    
    @IBAction func stealButtonTapped(_ sender: UIButton) {
        viewDelegate?.PJUserDetailsMoneyTableViewCellStealButtonTapped()
    }
}
