//
//  PJCatPlayDetailsView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/15.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJCatPlayDetailsView: UIView {

    var viewModel = PJPet.CatPlay() {
        didSet {
            msgDetailsView.viewModel = viewModel
        }
    }
    
    private var msgDetailsView = PJPetPlayDetailsView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        // 撸猫动图
        let activityImageView = UIImageView(frame: CGRect(x: 0, y: 36 * 1.385 + 40, width: pj_width * 0.53, height: pj_width * 0.53 * 1.124))
        activityImageView.x = (pj_width - pj_width * 0.53) / 2
        activityImageView.loadGif(asset: "timg")
        addSubview(activityImageView)
        
        let timeMsgView = UIView(frame: CGRect(x: 15, y: activityImageView.bottom + 30, width: pj_width - 30, height: 80))
        timeMsgView.layer.cornerRadius = timeMsgView.pj_height / 2
        msgDetailsView = PJPetPlayDetailsView.newInstance()
        msgDetailsView.pj_width = timeMsgView.pj_width - 30
        msgDetailsView.y = (timeMsgView.pj_height - msgDetailsView.pj_height) / 2
        msgDetailsView.x = 15
        timeMsgView.backgroundColor = msgDetailsView.backgroundColor
        
        timeMsgView.addSubview(msgDetailsView)
        addSubview(timeMsgView)
        
        let editButton = UIButton(frame: CGRect(x: 0, y: timeMsgView.bottom + 30, width: 120, height: 36))
        addSubview(editButton)
        editButton.x = (pj_width - 120) / 2
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
        addSubview(addButton)
        addButton.setTitle("手动添加", for: .normal)
        addButton.titleLabel?.font = editButton.titleLabel?.font
        addButton.setTitleColor(editButton.titleColor(for: .normal), for: .normal)
        addButton.setImage(UIImage(named: "pet_play_add"), for: .normal)
        addButton.addTarget(self, action: .edit, for: .touchUpInside)
        addButton.layer.cornerRadius = editButton.layer.cornerRadius
        addButton.clipsToBounds = true
        addButton.layer.borderColor = editButton.layer.borderColor
        addButton.layer.borderWidth = editButton.layer.borderWidth
    }

}

extension PJCatPlayDetailsView {
    @objc
    fileprivate func edit() {
        
    }
    
    @objc
    fileprivate func add() {
        
    }
}

private extension Selector {
    static let edit = #selector(PJCatPlayDetailsView.edit)
    static let add = #selector(PJCatPlayDetailsView.add)
}
