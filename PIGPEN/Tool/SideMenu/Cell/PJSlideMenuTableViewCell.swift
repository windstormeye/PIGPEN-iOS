//
//  PJSlideMenuTableViewCell.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/5/5.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJSlideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var tipsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var viewModel: ViewModel? {
        didSet { didSetViewModel() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func didSetViewModel() {
        tipsImageView.image = UIImage(named: viewModel!.imageName)
        titleLabel.text = viewModel!.title
    }
}


extension PJSlideMenuTableViewCell {
    struct ViewModel {
        var imageName: String
        var title: String
    }
}
