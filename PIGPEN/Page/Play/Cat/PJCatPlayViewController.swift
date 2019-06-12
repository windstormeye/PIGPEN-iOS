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

    var cat = PJPet()
    
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
        
        let avatarImageView = UIImageView(frame: CGRect(x: 15, y: 10 + navigationBarHeight, width: 36, height: 36))
        view.addSubview(avatarImageView)
        avatarImageView.image = UIImage(named: "pet_avatar")
        avatarImageView.layer.cornerRadius = avatarImageView.pj_width / 2
        
        let activityImageView = UIImageView(frame: CGRect(x: 0, y: avatarImageView.bottom + 40, width: view.pj_width * 0.53, height: view.pj_width * 0.53 * 1.124))
        activityImageView.centerX = view.centerX
        activityImageView.loadGif(asset: "timg")
        view.addSubview(activityImageView)
        
        timeLabel.frame = CGRect(x: 0, y: activityImageView.bottom + 80, width: view.pj_width, height: 87)
        timeLabel.textAlignment = .center
        timeLabel.textColor = .black
        timeLabel.font = UIFont.systemFont(ofSize: 72, weight: .medium)
        view.addSubview(timeLabel)
        
        let tipsLabel = UILabel(frame: CGRect(x: 0, y: timeLabel.bottom + 20, width: view.pj_width, height: 15))
        view.addSubview(tipsLabel)
        tipsLabel.font = UIFont.systemFont(ofSize: 11)
        tipsLabel.textColor = PJRGB(184, 180, 180)
        tipsLabel.textAlignment = .center
        tipsLabel.text = "退出程序后，默认撸猫自动结束"
        
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: .repeatTimer,
                                     userInfo: nil,
                                     repeats: true)
    }
}

extension PJCatPlayViewController {
    @objc
    fileprivate func back() {
        popBack()
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
}

private extension Selector {
    static let back = #selector(PJCatPlayViewController.back)
    static let repeatTimer = #selector(PJCatPlayViewController.repeatTimer)
}
