//
//  PJDogPlayViewController.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/13.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit
import CoreMotion

class PJDogPlayViewController: UIViewController, PJBaseViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    private func initView() {
        view.backgroundColor = .white
        
        initBaseView()
        titleString = "正在遛狗"
        backButtonTapped(backSel: .back, imageName: nil)
        
        let mapView = PJDogPlayMapView(frame: CGRect(x: 0, y: 0, width: view.pj_width, height: view.pj_height))
        view.addSubview(mapView)
        
        // 停止撸猫
        let stopButton = UIButton(frame: CGRect(x: 0, y: view.pj_height - 36 - 20 - bottomSafeAreaHeight, width: 120, height: 36))
        view.addSubview(stopButton)
        stopButton.setTitle("结束遛狗", for: .normal)
        stopButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        stopButton.backgroundColor = PJRGB(61, 44, 79)
        stopButton.layer.cornerRadius = stopButton.pj_height / 2
        stopButton.centerX = view.centerX
        stopButton.addTarget(self, action: .stop, for: .touchUpInside)
    }
}


extension PJDogPlayViewController {
    @objc
    fileprivate func back() {
        popBack()
    }
    
    @objc
    fileprivate func stop() {
        
    }
}

private extension Selector {
    static let back = #selector(PJDogPlayViewController.back)
    static let stop = #selector(PJDogPlayViewController.stop)
}
