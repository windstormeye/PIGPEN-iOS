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
    
    var cellType: PJDogPlayEditTableView.TableViewType = .play {
        didSet {
            switch cellType {
            case .play:
                firstTextLabel.text = "遛狗时间"
                secondTextLabel.text = "消耗热量"
            case .drink:
                firstTextLabel.text = "喝水时间"
                secondTextLabel.text = "喝水毫升"
            case .eat:
                firstTextLabel.text = "喂食时间"
                secondTextLabel.text = "喂食克数"
            }
        }
    }
    
    @IBOutlet private weak var firstValueLabel: UILabel!
    @IBOutlet private weak var secondValueLabel: UILabel!
    @IBOutlet private weak var firstTextLabel: UILabel!
    @IBOutlet private weak var secondTextLabel: UILabel!
    
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

