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

    
    @IBOutlet private weak var birthButton: UIButton!
    @IBOutlet private weak var weightButton: UIButton!
    @IBOutlet private weak var foodButton: UIButton!
    @IBOutlet private weak var petStatus0Button: UIButton!
    @IBOutlet private weak var petStatus1Button: UIButton!
    @IBOutlet private weak var petStatus2Button: UIButton!
    @IBOutlet private weak var doneButton: UIButton!
    
    private var rulerView = PJRulerPickerView()
    private var btns = [UIButton]()
    private var originBtns = [UIButton]()
    private var birthButtonTop: CGFloat = 0
    private var weightButtonTop: CGFloat = 0
    private var foodButtonTop: CGFloat = 0
    private var currentButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rulerView.top = birthButton.bottom
        
        birthButtonTop = birthButton.top
        weightButtonTop = weightButton.top
        foodButtonTop = foodButton.top
    }
    
    private func initView() {
        view.backgroundColor = .white
        initBaseView()
        backButtonTapped(backSel: .back, imageName: nil)
        
        doneButton.defualtStyle(nil)
        
        birthButton.layer.cornerRadius = birthButton.pj_height / 2
        birthButton.addTarget(self, action: .btnTapper, for: .touchUpInside)
        btns.append(birthButton)
        originBtns.append(birthButton)
        
        weightButton.layer.cornerRadius = weightButton.pj_height / 2
        weightButton.addTarget(self, action: .btnTapper, for: .touchUpInside)
        btns.append(weightButton)
        originBtns.append(weightButton)
        
        foodButton.layer.cornerRadius = foodButton.pj_height / 2
        foodButton.addTarget(self, action: .btnTapper, for: .touchUpInside)
        btns.append(foodButton)
        originBtns.append(foodButton)
        
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
        
        rulerView = PJRulerPickerView(frame: CGRect(x: 0, y: 0, width: view.pj_width, height: 30), pickCount: 100)
        view.addSubview(rulerView)
        rulerView.isHidden = true
        rulerView.alpha = 0
        rulerView.moved = {
            print($0)
        }
    }
}

private extension Selector {
    static let back = #selector(PJCreatePetSelfDetailsViewController.back)
    static let done = #selector(PJCreatePetSelfDetailsViewController.done)
    static let btnTapper = #selector(PJCreatePetSelfDetailsViewController.btnTapper(sender:))
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
    
    @objc
    fileprivate func btnTapper(sender: UIButton) {
        let btnTag = sender.tag
        rulerView.isHidden = true
        rulerView.alpha = 0
        
        for index in 0..<originBtns.count {
            UIView.animate(withDuration: 0.25) {
                switch index {
                case 0:
                    self.btns[0].top = self.birthButtonTop
                case 1:
                    self.btns[1].top = self.weightButtonTop
                case 2:
                    self.btns[2].top = self.foodButtonTop
                default:
                    break
                }
            }
        }
        
        if currentButton != sender {
            currentButton = sender
            
            var moveHeight: CGFloat = 40
            switch sender.tag {
            case 0:
                moveHeight = 70
            case 1:
                moveHeight = 40
            case 2:
                moveHeight = 70
            default:
                break
            }
            
            let _ = btns.filter { b in
                if b.tag <= btnTag {
                    UIView.animate(withDuration: 0.25, animations: {
                        b.top -= moveHeight
                    })
                }
                return true
            }
            
            rulerView.isHidden = false
            UIView.animate(withDuration: 0.85) {
                self.rulerView.alpha = 1
            }
            rulerView.top = sender.bottom + 10
        } else {
            currentButton = UIButton()
        }
    }
}
