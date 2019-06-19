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
            var finalTiemString = "0 min"
            
            if viewModel.time > 60 {
                finalTiemString = "\(viewModel.time / 60) min"
            }
            
            if viewModel.time > 3600 {
                finalTiemString = "\(viewModel.time / 3600) H"
            }
            
            timeLabel.text = finalTiemString
            distanceLabel.text = "\(Double(viewModel.distance * 0.001).roundTo(places: 2)) KM"
            remainingDistanceLabel.text = "\(viewModel.remainningDistance) KM"
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
        var time: Int
        var distance: Double
        var remainningDistance: Int
        var pet: PJPet.Pet
        
        init() {
            time = 0
            distance = 0
            remainningDistance = 0
            pet = PJPet.Pet()
        }
    }
}
