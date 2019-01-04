//
//  PJGradeViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/12/24.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJGradeViewController: PJBaseViewController {
    // MARK: - Private Properties
    private var waterView: PJWaveView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView?.backgroundColor = .white
        isHiddenBarBottomLineView = false
        navigationItem.title = "我的评分"
        view.backgroundColor = .white
        
        
        let segment = PJSegmentView(frame: CGRect(x: 0,
                                                  y: headerView!.bottom,
                                                  width: PJSCREEN_WIDTH,
                                                  height: 50))
        view.addSubview(segment)
        segment.viewModel = PJSegmentView.ViewModel(titles: ["昨日", "周评分", "月评分", "总评分"])
        
        waterView = PJWaveView.init(frame: CGRect(x: 0, y: segment.bottom, width: self.view.width, height: self.view.height))
        waterView?.viewModel = PJWaveView.ViewModel(level: 7.4, containerHeight: self.view.height)
        view.addSubview(waterView!)
        
        waterView?.viewModel!.level = 10
    }

}
