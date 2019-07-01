//
//  PJDogPlayEditOldTableViewCell.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/27.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJDogPlayEditOldTableViewCell: UITableViewCell {

    var viewModel = PJDogPlayEditTableViewCell.ViewModel() {
        didSet {
            initView()
        }
    }
    
    @IBOutlet private weak var firstValueLabel: UILabel!
    @IBOutlet private weak var secondValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let topLine = UIView(frame: CGRect(x: 48, y: 0, width: 1, height: 43 / 2 - 4))
        addSubview(topLine)
        topLine.backgroundColor = PJRGB(240, 240, 240)
        
        let redDotImageView = UIImageView(frame: CGRect(x: 46.5, y: topLine.bottom + 2, width: 4, height: 4))
        addSubview(redDotImageView)
        redDotImageView.image = UIImage(named: "pet_play_edit_side_ blackDot")
        
        let bottomLine = UIView(frame: CGRect(x: 48, y: redDotImageView.bottom + 2, width: 1, height: pj_height - redDotImageView.bottom - 2))
        addSubview(bottomLine)
        bottomLine.backgroundColor = PJRGB(240, 240, 240)
    }
    
    private func initView() {
        firstValueLabel.text = " \(viewModel.firstValue)"
        secondValueLabel.text = " \(viewModel.secondValue)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

