//
//  PJCreatePetSelfDetailsViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/5/15.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJCreatePetSelfDetailsViewController: UIViewController, PJBaseViewControllerDelegate {
    var pet = PJPet.Pet()
    // 上传
    var imgKey = ""
    // 关系代码 -1 黑户
    var relation_code = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        view.backgroundColor = .white
        initBaseView()
        backButtonTapped(backSel: .back, imageName: nil)
        
        switch pet.pet_type {
        case .cat:
            titleString = "添加猫咪"
//            breedButton.setTitle("请选择猫咪品种", for: .normal)
//            relationButton.setTitle("请选择猫咪和您的关系", for: .normal)
        case .dog:
            titleString = "添加狗狗"
//            breedButton.setTitle("请选择狗狗品种", for: .normal)
//            relationButton.setTitle("请选择狗狗和您的关系", for: .normal)
        }
    }
}

private extension Selector {
    static let back = #selector(PJCreatePetSelfDetailsViewController.back)
    static let done = #selector(PJCreatePetSelfDetailsViewController.done)
}

extension PJCreatePetSelfDetailsViewController {
    @objc
    fileprivate func back() {
        popBack()
    }
    
    @objc
    fileprivate func done() {
        print(pet)
    }
}
