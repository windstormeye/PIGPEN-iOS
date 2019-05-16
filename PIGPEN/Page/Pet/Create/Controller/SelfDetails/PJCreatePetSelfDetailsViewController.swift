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

    
    @IBOutlet weak var birthButton: UIButton!
    @IBOutlet weak var weightButton: UIButton!
    @IBOutlet weak var foodButton: UIButton!
    @IBOutlet weak var petStatus0Button: UIButton!
    @IBOutlet weak var petStatus1Button: UIButton!
    @IBOutlet weak var petStatus2Button: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        view.backgroundColor = .white
        initBaseView()
        backButtonTapped(backSel: .back, imageName: nil)
        
        doneButton.defualtStyle(nil)
        birthButton.layer.cornerRadius = birthButton.pj_height / 2
        weightButton.layer.cornerRadius = weightButton.pj_height / 2
        foodButton.layer.cornerRadius = foodButton.pj_height / 2
        
        petStatus0Button.topImageBottomTitle(titleTop: 20)
        petStatus1Button.topImageBottomTitle(titleTop: 20)
        petStatus2Button.topImageBottomTitle(titleTop: 20)
        
        switch pet.pet_type {
        case .cat:
            titleString = "添加猫咪"
            birthButton.setTitle("猫咪的生日", for: .normal)
            weightButton.setTitle("请选择猫咪的体重", for: .normal)
            foodButton.setTitle("请选择猫咪的每日喂食量", for: .normal)
        case .dog:
            titleString = "添加狗狗"
            birthButton.setTitle("狗狗的生日", for: .normal)
            weightButton.setTitle("请选择狗狗的体重", for: .normal)
            foodButton.setTitle("请选择狗狗的每日喂食量", for: .normal)
        }
        
        let rulerView = PJRulerPickerView(frame: CGRect(x: 0, y: 100, width: view.pj_width, height: 100), pickCount: 100)
        view.addSubview(rulerView)
        rulerView.isHidden = true
        rulerView.moved = {
            print($0)
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
