//
//  PJDogPlayDetailsView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/13.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJDogPlayDetailsView: UIView {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var remainingDistanceLabel: UILabel!
    
    var viewModel: ViewModel? {
        didSet {
            timeLabel.text = viewModel?.time
            distanceLabel.text = viewModel?.distance
            remainingDistanceLabel.text = viewModel?.remainningDistance
        }
    }
    
    class func newInstance() -> PJDogPlayDetailsView {
        return Bundle.main.loadNibNamed("PJDogPlayDetailsView",
                                        owner: self,
                                        options: nil)!.first as! PJDogPlayDetailsView
    }
}

extension PJDogPlayDetailsView {
    struct ViewModel {
        var time: String
        var distance: String
        var remainningDistance: String
    }
}
