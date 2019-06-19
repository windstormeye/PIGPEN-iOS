//
//  PJDogPlayDetailsView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/13.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJDogPlayDetailsView: UIView {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var remainingDistanceLabel: UILabel!
    
    var viewModel = ViewModel() {
        didSet {
            avatarImageView.kf.setImage(with: URL(string: viewModel.pet.avatar_url))
            timeLabel.text = viewModel.time
            distanceLabel.text = viewModel.distance
            remainingDistanceLabel.text = viewModel.remainningDistance
        }
    }
    
    class func newInstance() -> PJDogPlayDetailsView {
        return Bundle.main.loadNibNamed("PJDogPlayDetailsView",
                                        owner: self,
                                        options: nil)!.first as! PJDogPlayDetailsView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.cornerRadius = avatarImageView.pj_height / 2
    }
}

extension PJDogPlayDetailsView {
    struct ViewModel {
        var time: String
        var distance: String
        var remainningDistance: String
        var pet: PJPet.Pet
        
        init() {
            time = "0 min"
            distance = "0 KM"
            remainningDistance = "0 KM"
            pet = PJPet.Pet()
        }
    }
}
