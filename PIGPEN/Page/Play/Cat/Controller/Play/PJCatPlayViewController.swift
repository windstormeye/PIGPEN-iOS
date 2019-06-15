//
//  PJCatPlayViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/6/12.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class PJCatPlayViewController: UIViewController, PJBaseViewControllerDelegate {

    var viewModels = [PJPet.Pet]()
    
    private var avatarImageView = UIImageView()
    
    /// 撸猫持续时间
    private var durationSeconds = 0
    private var durationMins = 0
    private var durationHours = 0
    /// 当前时间戳
    private let currentTimeStamp = Int(Date().timeIntervalSince1970)
    private var timeLabel = UILabel()
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    private func initView() {
        view.backgroundColor = .white
        titleString = "撸猫"
        backButtonTapped(backSel: .back, imageName: nil)
        
        // 头像
        avatarImageView = UIImageView(frame: CGRect(x: 15, y: 10 + navigationBarHeight, width: 36, height: 36))
        view.addSubview(avatarImageView)
        avatarImageView.layer.cornerRadius = avatarImageView.pj_width / 2
        
        // 撸猫动图
        let activityImageView = UIImageView(frame: CGRect(x: 0, y: avatarImageView.bottom + 40, width: view.pj_width * 0.53, height: view.pj_width * 0.53 * 1.124))
        activityImageView.centerX = view.centerX
        activityImageView.loadGif(asset: "timg")
        view.addSubview(activityImageView)
        
        // 计时器
        timeLabel.frame = CGRect(x: 0, y: activityImageView.bottom + 80, width: view.pj_width, height: 87)
        timeLabel.textAlignment = .center
        timeLabel.textColor = .black
        timeLabel.font = UIFont.systemFont(ofSize: 72, weight: .medium)
        view.addSubview(timeLabel)
        
        // 提示语
        let tipsLabel = UILabel(frame: CGRect(x: 0, y: timeLabel.bottom + 20, width: view.pj_width, height: 15))
        view.addSubview(tipsLabel)
        tipsLabel.font = UIFont.systemFont(ofSize: 11)
        tipsLabel.textColor = PJRGB(184, 180, 180)
        tipsLabel.textAlignment = .center
        tipsLabel.text = "退出程序后，默认撸猫自动结束"
        
        // 停止撸猫
        let stopButton = UIButton(frame: CGRect(x: 0, y: view.pj_height - 36 - 20 - bottomSafeAreaHeight, width: 120, height: 36))
        view.addSubview(stopButton)
        stopButton.setTitle("结束撸猫", for: .normal)
        stopButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        stopButton.backgroundColor = PJRGB(61, 44, 79)
        stopButton.layer.cornerRadius = stopButton.pj_height / 2
        stopButton.centerX = view.centerX
        stopButton.addTarget(self, action: .stop, for: .touchUpInside)
        
        // SE 上的效果
        if tipsLabel.bottom > stopButton.top {
            tipsLabel.bottom = stopButton.top - 20
            timeLabel.bottom = tipsLabel.top - 20
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: .repeatTimer,
                                     userInfo: nil,
                                     repeats: true)
        
        NotificationCenter.default.addObserver(self,
                                               selector: .stop,
                                               name: .enterBackground(),
                                               object: nil)
    }
    
    func updateData() {
//        avatarImageView.kf.setImage(with: URL(string: viewModel.avatar_url))
    }
}

extension PJCatPlayViewController {
    @objc
    fileprivate func back() {
        popBack()
        stop()
    }
    
    @objc
    fileprivate func repeatTimer() {
        durationSeconds += 1
        
        if durationSeconds >= 60 {
            durationSeconds = 0
            durationMins += 1
        }
        if durationMins >= 60 {
            durationMins = 0
            durationHours += 1
        }
        
        var hours = ""
        if durationHours == 0 {
            hours = "00"
        } else {
            if durationHours >= 10 {
                hours = String(durationHours)
            } else {
                hours = "0" + String(durationHours)
            }
        }
        
        var mins = ""
        if durationMins == 0 {
            mins = "00"
        } else {
            if durationMins >= 10 {
                mins = String(durationMins)
            } else {
                mins = "0" + String(durationMins)
            }
        }
        
        var seconds = ""
        if durationSeconds == 0 {
            seconds = "00"
        } else {
            if durationSeconds >= 10 {
                seconds = String(durationSeconds)
            } else {
                seconds = "0" + String(durationSeconds)
            }
        }
        
        timeLabel.text = hours + ":" + mins + ":" + seconds
    }
    
    @objc
    fileprivate func stop() {
        timer!.invalidate()
        
        let duration = durationSeconds + durationMins * 60 + durationHours * 3600
        print(duration)
    }
}

private extension Selector {
    static let back = #selector(PJCatPlayViewController.back)
    static let repeatTimer = #selector(PJCatPlayViewController.repeatTimer)
    static let stop = #selector(PJCatPlayViewController.stop)
}
