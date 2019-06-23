//
//  PJDogPlayFinishDetailsView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/22.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJDogPlayFinishDetailsView: UIView {

    var viewModel = ViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, viewModel: ViewModel) {
        self.init(frame: frame)
        self.viewModel = viewModel
        initView()
    }
    
    private func initView() {
        let mapImageView = UIImageView(frame: CGRect(x: 15, y: 0, width: pj_width - 30, height: pj_width - 30))
        addSubview(mapImageView)
        mapImageView.image = viewModel.mapImage
    }
}

extension PJDogPlayFinishDetailsView {
    struct ViewModel {
        var mapImage: UIImage
        var durations: Int
        var distance: CGFloat
        var kcal: Int
        
        init() {
            durations = 0
            distance = 0
            kcal = 0
            mapImage = UIImage()
        }
    }
}
