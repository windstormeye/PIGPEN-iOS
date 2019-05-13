//
//  PJCreatePetDetailsViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/5/13.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit
class PJCreatePetDetailsViewController: UIViewController, PJBaseViewControllerDelegate {
    var pet = PJPet.Pet()
    // 上传
    var imgKey = ""
    
    @IBOutlet weak var breedButton: UIButton!
    @IBOutlet weak var relationButton: UIButton!
    @IBOutlet weak var singleButton: UIButton!
    @IBOutlet weak var datingButton: UIButton!
    @IBOutlet weak var alienButton: UIButton!
    @IBOutlet weak var unpButton: UIButton!
    @IBOutlet weak var pButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        initBaseView()
        backButtonTapped(backSel: .back, imageName: nil)
        
        switch pet.pet_type {
        case .cat:
            titleString = "添加猫咪"
            breedButton.setTitle("请选择猫咪品种", for: .normal)
            relationButton.setTitle("请选择猫咪和您的关系", for: .normal)
        case .dog:
            titleString = "添加狗狗"
            breedButton.setTitle("请选择狗狗品种", for: .normal)
            relationButton.setTitle("请选择狗狗和您的关系", for: .normal)
        }

        breedButton.layer.cornerRadius = breedButton.pj_height / 2
        relationButton.layer.cornerRadius = relationButton.pj_height / 2
        
        doneButton.defualtStyle(nil)
    }
}

private extension Selector {
    static let back = #selector(PJCreatePetDetailsViewController.back)
}

extension PJCreatePetDetailsViewController {
    @objc
    fileprivate func back() {
        popBack()
    }
}
