//
//  PJCatPlayHomeViewController.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/15.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJCatPlayHomeViewController: UIViewController, PJBaseViewControllerDelegate {

    var viewModels = [PJPet.Pet]()
    
    private var avatarView = PJPetAvatarView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(viewModels: [PJPet.Pet]) {
        self.init(nibName: nil, bundle: nil)
        self.viewModels = viewModels
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        initBaseView()
        view.backgroundColor = .white
        titleString = "撸猫"
        backButtonTapped(backSel: .back, imageName: nil)
        
        avatarView = PJPetAvatarView(frame: CGRect(x: 20, y: navigationBarHeight, width: view.pj_width - 40, height: 36 * 1.385), viewModel: viewModels)
        avatarView.scrollToButton(0)
        view.addSubview(avatarView)
        
        // 撸猫动图
        let activityImageView = UIImageView(frame: CGRect(x: 0, y: avatarView.bottom + 40, width: view.pj_width * 0.53, height: view.pj_width * 0.53 * 1.124))
        activityImageView.centerX = view.centerX
        activityImageView.loadGif(asset: "timg")
        view.addSubview(activityImageView)
    }
}

extension PJCatPlayHomeViewController {
    @objc
    fileprivate func back() {
        popBack()
    }
}

private extension Selector {
    static let back = #selector(PJCatPlayHomeViewController.back)
}
