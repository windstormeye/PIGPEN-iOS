//
//  PJCatPlayViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/6/12.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit
import Kingfisher

class PJCatPlayViewController: UIViewController, PJBaseViewControllerDelegate {

    var cat = PJPet()
    
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
        
        let activityImageView = UIImageView(frame: CGRect(x: 0, y: avatarImageView.bottom + 20, width: view.pj_width * 0.53, height: view.pj_width * 0.53 * 1.124))
        let path = Bundle.main.path(forResource:"timg.gif", ofType:nil)
        activityImageView.kf.setImage(with:URL(fileURLWithPath: path!))
        view.addSubview(activityImageView)
        
    }
}

extension PJCatPlayViewController {
    @objc
    fileprivate func back() {
        popBack()
    }
}

private extension Selector {
    static let back = #selector(PJCatPlayViewController.back)
}
