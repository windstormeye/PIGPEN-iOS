//
//  PJDogPlayEditTableViewCell.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/23.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJDogPlayEditTableViewCell: UITableViewCell {
    @IBOutlet private weak var secondValueLabel: UILabel!
    @IBOutlet private weak var secondTextLabel: UILabel!
    @IBOutlet private weak var firstValueLabel: UILabel!
    @IBOutlet private weak var firstTextLabel: UILabel!
    @IBOutlet private weak var bgImageView: UIImageView!
    
    var viewModel = ViewModel() {
        didSet {
            initView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let topLine = UIView(frame: CGRect(x: 48, y: 0, width: 1, height: 58 / 2 - 4))
        addSubview(topLine)
        topLine.backgroundColor = PJRGB(240, 240, 240)
        
        let redDotImageView = UIImageView(frame: CGRect(x: 46.5, y: topLine.bottom + 2, width: 4, height: 4))
        addSubview(redDotImageView)
        redDotImageView.image = UIImage(named: "pet_play_edit_side_redDot")
        
        
        let bottomLine = UIView(frame: CGRect(x: 48, y: redDotImageView.bottom + 2, width: 1, height: pj_height - redDotImageView.bottom - 2))
        addSubview(bottomLine)
        bottomLine.backgroundColor = PJRGB(240, 240, 240)
    }
    
    private func initView() {
        firstValueLabel.text = viewModel.firstValue
        secondValueLabel.text = viewModel.secondValue
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        
    }
    
    /// 更新 cell 背景图片
    func updateBackgroundImage(_ imageName: String) {
        bgImageView.image = UIImage(named: imageName)
    }
}

extension PJDogPlayEditTableViewCell {
    struct ViewModel {
        var firstValue: String
        var secondValue: String
        
        init() {
            firstValue = ""
            secondValue = ""
        }
    }
}
