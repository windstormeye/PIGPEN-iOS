//
//  PJGradeViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/12/24.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJGradeViewController: PJBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView?.backgroundColor = .white
        isHiddenBarBottomLineView = false
        navigationItem.title = "我的评分"

        let segment = PJSegmentView(frame: CGRect(x: 0, y: headerView!.bottom, width: PJSCREEN_WIDTH, height: 50))
        view.addSubview(segment)
        segment.viewModel = PJSegmentView.ViewModel(titles: ["昨日", "周评分", "月评分", "总评分"])
        
//        let vc1 = PJGradeYesterdayViewController()
//        let vc2 = PJGradeWeekViewController()
//
//        vc1.view.x = 0
//        vc2.view.x = 50
//
//        view.addSubview(vc1.view)
//        view.addSubview(vc2.view)
    }

}
