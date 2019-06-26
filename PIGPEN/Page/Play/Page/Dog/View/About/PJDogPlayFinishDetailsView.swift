//
//  PJDogPlayFinishDetailsView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/22.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJDogPlayFinishDetailsView: UIView {
    var backSelected: (() -> Void)?
    var finishSelected: (() -> Void)?
    
    var viewModel = ViewModel() {
        didSet {
            var viewModel = PJPetAboutScoreView.ViewModel()
            
            var minString = "\(self.viewModel.durations / 60) min"
            var hourString = ""
            
            if self.viewModel.durations / 60 > 60 {
                let hours = self.viewModel.durations / 3600
                hourString = "\(hours) h "
                
                let mins = (self.viewModel.durations - hours * 3600) / 60
                minString = "\(mins) min"
            }
            
            viewModel.firstValue = hourString + minString
            viewModel.secondValue = String(format: "%.2f km", self.viewModel.distance)
            viewModel.thirdValue = "\(self.viewModel.kcal * 0.01) kcal"
            viewModel.score = self.viewModel.score * 0.01
            
            mapImageView.image = self.viewModel.mapImage
            
            detailsView.viewModel = viewModel
        }
    }
    
    private var detailsView = PJPetAboutScoreView()
    private var mapImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, viewModel: ViewModel) {
        self.init(frame: frame)
        initView()
        self.viewModel = viewModel
    }
    
    private func initView() {
        mapImageView = UIImageView(frame: CGRect(x: 15, y: 0, width: pj_width - 30, height: pj_width - 30))
        addSubview(mapImageView)
        
        detailsView = PJPetAboutScoreView.newInstance()
        detailsView.frame = CGRect(x: (pj_width - 346) / 2, y: mapImageView.bottom + 20, width: 346, height: 102)
        detailsView.top = mapImageView.bottom + 20
        addSubview(detailsView)
        
        var bottomViewModel = PJBottomSelectedButtonView.ViewModel()
        bottomViewModel.firstValue = "继续遛狗"
        bottomViewModel.secondValue = "提交"
        
        let bottomButtonView = PJBottomSelectedButtonView(frame: CGRect(x: 0, y: pj_height - 60, width: pj_width, height: 40), viewModel: bottomViewModel)
        addSubview(bottomButtonView)
        bottomButtonView.firstSelected = {
            self.backSelected?()
        }
        bottomButtonView.secondSelected = {
            self.finishSelected?()
        }
    }
}

extension PJDogPlayFinishDetailsView {
    struct ViewModel {
        var mapImage: UIImage
        var durations: Int
        var distance: CGFloat
        var kcal: CGFloat
        var score: CGFloat
        
        init() {
            durations = 0
            distance = 0
            kcal = 0
            score = 0
            mapImage = UIImage()
        }
    }
}
