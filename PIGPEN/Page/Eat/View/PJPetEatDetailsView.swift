//
//  PJPetDrinkDetailsView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/2.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJPetEatDetailsView: UIView {
  
    var editSelected: (() -> Void)?
    var manualSelected: ((Int) -> Void)?
    
    var itemSelectedViewHidded = false {
        didSet {
            manualAddKcalView.isHidden = itemSelectedViewHidded
        }
    }
    
    var viewModel = ViewModel() {
        didSet {
            var detailsViewModel = PJPetPlayDetailsView.ViewModel()
            detailsViewModel.firstString = "\(viewModel.eat.food_target_today) g"
            detailsViewModel.secondString = String(viewModel.eat.times)
            detailsViewModel.thirdString = "\(viewModel.eat.foods_today) g"
            detailsViewModel.score = CGFloat(viewModel.eat.score)
            
            msgDetailsView.viewModel = detailsViewModel
        }
    }
    
    private var msgDetailsView = PJPetPlayDetailsView()
    private var manualAddKcalView = PJManualAddKcalView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, viewModel: ViewModel) {
        self.init(frame: frame)
        self.viewModel = viewModel
        initView()
    }
    
    private func initView() {
        // 撸猫动图
        let activityImageView = UIImageView(frame: CGRect(x: 0, y: 36 * 1.385 + 20, width: pj_width * 0.53, height: pj_width * 0.53 * 1.124))
        activityImageView.x = (pj_width - pj_width * 0.53) / 2
        activityImageView.loadGif(asset: "timg")
        addSubview(activityImageView)
        
        let timeMsgView = UIView(frame: CGRect(x: 15, y: activityImageView.bottom + 30, width: pj_width - 30, height: 80))
        timeMsgView.layer.cornerRadius = timeMsgView.pj_height / 2
        msgDetailsView = PJPetPlayDetailsView.newInstance()
        msgDetailsView.pj_width = timeMsgView.pj_width - 30
        msgDetailsView.y = (timeMsgView.pj_height - msgDetailsView.pj_height) / 2
        msgDetailsView.x = 15
        msgDetailsView.updateLabel(firstString: "每日目标", secondString: "今日次数", thirdString: "今日总量")
        timeMsgView.backgroundColor = msgDetailsView.backgroundColor
        timeMsgView.addSubview(msgDetailsView)
        addSubview(timeMsgView)
        
        let editButton = UIButton(frame: CGRect(x: 0, y: timeMsgView.bottom + 10, width: 90, height: 20))
        addSubview(editButton)
        editButton.right = pj_width - 20
        editButton.setTitle("修改记录", for: .normal)
        editButton.setImage(UIImage(named: "pet_play_edit"), for: .normal)
        editButton.addTarget(self, action: .edit, for: .touchUpInside)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        editButton.setTitleColor(.black, for: .normal)
        
        let addButton = UIButton(frame: CGRect(x: (pj_width - 120) / 2, y: pj_height - 36 - 20, width: 120, height: 36))
        addSubview(addButton)
        addButton.setTitle("手动添加", for: .normal)
        addButton.titleLabel?.font = editButton.titleLabel?.font
        addButton.setTitleColor(editButton.titleColor(for: .normal), for: .normal)
        addButton.setImage(UIImage(named: "pet_play_add"), for: .normal)
        addButton.addTarget(self, action: .add, for: .touchUpInside)
        addButton.layer.cornerRadius = addButton.pj_height / 2
        addButton.clipsToBounds = true
        addButton.layer.borderColor = UIColor.black.cgColor
        addButton.layer.borderWidth = 1
        
        manualAddKcalView = PJManualAddKcalView(frame: CGRect(x: 0, y: addButton.top - 20, width: pj_width, height: 60), pickCount: 2000, tipsText: "g")
        manualAddKcalView.isHidden = true
        manualAddKcalView.alpha = 0
        manualAddKcalView.itemSelected = {
            self.manualSelected?($0)
        }
        addSubview(manualAddKcalView)
    }
}

extension PJPetEatDetailsView {
    @objc
    fileprivate func edit() {
        editSelected?()
    }
    
    @objc
    fileprivate func add() {
        manualAddKcalView.isHidden = false
        UIView.animate(withDuration: 0.25) {
            self.manualAddKcalView.alpha = 1
        }
    }
}

private extension Selector {
    static let edit = #selector(PJPetEatDetailsView.edit)
    static let add = #selector(PJPetEatDetailsView.add)
}

extension PJPetEatDetailsView {
    struct ViewModel {
        var eat: PJPet.PetEat
        var pet: PJPet.Pet
        
        init() {
            eat = PJPet.PetEat()
            pet = PJPet.Pet()
        }
    }
}
