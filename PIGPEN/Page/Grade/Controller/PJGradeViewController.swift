//
//  PJGradeViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/12/24.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit
import Kingfisher

class PJGradeViewController: PJBaseViewController {
    // MARK: - Private Properties
    private var waterView: PJWaveView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView?.backgroundColor = .white
        isHiddenBarBottomLineView = false
        backButtonTapped(backSel: .back)
        
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
        
//        let url = URL(string: "http://pigpenimg.pjhubs.com/pigpenpet_avatar15467606501.jpeg?e=1546764253&token=HUFE4cvWpUrohdU7w1HU-Lb82jOvI58er5DlPSDs:GKtK5OOH3Zefbo5vT6Gq3GHeK5I=")
//        let imgv = UIImageView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
//        imgv.kf.setImage(with: url)
//        view.addSubview(imgv)

    }

}

// MARK: - Selector
fileprivate extension Selector {
    static let back = #selector(PJGradeViewController.back)
}

extension PJGradeViewController {
    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }
}
