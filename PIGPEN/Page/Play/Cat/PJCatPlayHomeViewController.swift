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
        
        let timeMsgView = UIView(frame: CGRect(x: 15, y: activityImageView.bottom + 30, width: view.pj_width - 30, height: 80))
        timeMsgView.layer.cornerRadius = timeMsgView.pj_height / 2
        let msgDetailsView = PJPetPlayDetailsView.newInstance()
        msgDetailsView.pj_width = timeMsgView.pj_width
        msgDetailsView.y = (timeMsgView.pj_height - msgDetailsView.pj_height) / 2
        timeMsgView.backgroundColor = msgDetailsView.backgroundColor
        
        timeMsgView.addSubview(msgDetailsView)
        view.addSubview(timeMsgView)
        
        let editButton = UIButton(frame: CGRect(x: 0, y: timeMsgView.bottom + 30, width: 120, height: 36))
        view.addSubview(editButton)
        editButton.centerX = view.centerX
        editButton.setTitle("修改记录", for: .normal)
        editButton.setImage(UIImage(named: "pet_play_edit"), for: .normal)
        editButton.addTarget(self, action: .edit, for: .touchUpInside)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        editButton.layer.cornerRadius = editButton.pj_height / 2
        editButton.clipsToBounds = true
        editButton.layer.borderColor = UIColor.black.cgColor
        editButton.layer.borderWidth = 1.5
        editButton.setTitleColor(.black, for: .normal)
        
        let addButton = UIButton(frame: CGRect(x: editButton.x, y: editButton.bottom + 20, width: editButton.pj_width, height: editButton.pj_height))
        view.addSubview(addButton)
        addButton.setTitle("手动添加", for: .normal)
        addButton.titleLabel?.font = editButton.titleLabel?.font
        addButton.setTitleColor(editButton.titleColor(for: .normal), for: .normal)
        addButton.setImage(UIImage(named: "pet_play_add"), for: .normal)
        addButton.addTarget(self, action: .edit, for: .touchUpInside)
        addButton.layer.cornerRadius = editButton.layer.cornerRadius
        addButton.clipsToBounds = true
        addButton.layer.borderColor = editButton.layer.borderColor
        addButton.layer.borderWidth = editButton.layer.borderWidth
        
        let bottomView = PJBottomDotButtonView(frame: CGRect(x: 0, y: view.pj_height - bottomSafeAreaHeight - 40, width: view.pj_width, height: 36), pageCount: viewModels.count - 1)
        view.addSubview(bottomView)
        
        avatarView.itemSelected = {
            bottomView.updateDot($0)
        }
    }
}

extension PJCatPlayHomeViewController {
    @objc
    fileprivate func back() {
        popBack()
    }
    
    @objc
    fileprivate func edit() {
        
    }
    
    @objc
    fileprivate func add() {
        
    }
}

private extension Selector {
    static let back = #selector(PJCatPlayHomeViewController.back)
    static let edit = #selector(PJCatPlayHomeViewController.edit)
    static let add = #selector(PJCatPlayHomeViewController.add)
}
