//
//  PJUserDetailsMoneyTableViewCell.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/12.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit


class PJUserDetailsMoneyTableViewCell: UITableViewCell {

    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var lookButton: UIButton!
    @IBOutlet weak var stealButton: UIButton!
    
    var viewDelegate: PJUserDetailsMoneyTableViewCellDelegate?
    var viewModel: ViewModel? { didSet { didSetViewModel() } }
    
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

// MARK: Setter & Getter
extension PJUserDetailsMoneyTableViewCell {
    func didSetViewModel() {
        moneyLabel.text = String(viewModel?.money ?? 0) + " 斤"
    }
}

// MARK: Protocol
protocol PJUserDetailsMoneyTableViewCellDelegate {
    func PJUserDetailsMoneyTableViewCellLookButtonTapped()
    func PJUserDetailsMoneyTableViewCellStealButtonTapped()
}

extension PJUserDetailsMoneyTableViewCellDelegate {
    func PJUserDetailsMoneyTableViewCellLookButtonTapped() {}
    func PJUserDetailsMoneyTableViewCellStealButtonTapped() {}
}

// MARK: ViewModel
extension PJUserDetailsMoneyTableViewCell {
    struct ViewModel {
        // 猪饲料
        var money: Int = 0
    }
}
