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

    @IBOutlet private weak var bithButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var weightButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var foodButtonBottomConstrain: NSLayoutConstraint!
    
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
    
    // 生日开始年份
    private var startYear = 1990
    // 体重上限（kg）
    private let maxWeight = 100
    // 喂食量上限（g）
    private var maxFood = 5000
    
    private var birthButtonTop: CGFloat = 0
    private var weightButtonTop: CGFloat = 0
    private var foodButtonTop: CGFloat = 0
    
    private var currentButton = UIButton()
    
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
        birthButton.addTarget(self, action: .btnTapper, for: .touchUpInside)
        btns.append(birthButton)
        originBtns.append(birthButton)
        
        weightButton.layer.cornerRadius = weightButton.pj_height / 2
        weightButton.addTarget(self, action: .btnTapper, for: .touchUpInside)
        weightButton.adjustsImageWhenHighlighted = false
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
            switch self.currentButton.tag % 100 {
            case 1:
                self.currentButton.setTitle("\($0)", for: .normal)
                self.currentButton.setTitleColor(.black, for: .normal)
            default:
                break
            }
        }
    }
    
    private func initData() {
        
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
    
    func updateRulerView(_ top: CGFloat?) {
        
        rulerView.isHidden = true
        rulerView.alpha = 0
        
        if top != nil {
            UIView.animate(withDuration: 0.25, animations: {
                self.rulerView.top = top!
            }) { (finished) in
                if finished {
                    self.rulerView.isHidden = false
                    UIView.animate(withDuration: 0.25, animations: {
                        self.rulerView.alpha = 1
                    })
                }
            }
        }
    }
    
    @objc
    fileprivate func btnTapper(sender: UIButton) {
        
        switch sender.tag % 100 {
        case 0:
            if sender.tag < 100 {
                UIView.animate(withDuration: 0.25) {
                    self.bithButtonBottomConstraint.constant = 70 + 40
                    sender.tag += 100

                    self.weightButtonBottomConstraint.constant = 40
                    self.weightButton.tag %= 100
                    
                    self.foodButtonBottomConstrain.constant = 40
                    self.foodButton.tag %= 100
                    
                    self.view.layoutIfNeeded()
                    self.updateRulerView(sender.bottom + 20)
                    self.currentButton = sender
                }
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.bithButtonBottomConstraint.constant = 40
                    
                    self.updateRulerView(nil)
                    sender.tag %= 100
                    self.view.layoutIfNeeded()
                    self.currentButton = UIButton()
                }
            }
        case 1:
            if sender.tag < 100 {
                UIView.animate(withDuration: 0.25) {
                    self.weightButtonBottomConstraint.constant = 40 + self.rulerView.pj_height
                    sender.tag += 100
                    
                    self.bithButtonBottomConstraint.constant = 40
                    self.birthButton.tag %= 100
                    
                    self.foodButtonBottomConstrain.constant = 40
                    self.foodButton.tag %= 100
                    
                    self.view.layoutIfNeeded()
                    self.updateRulerView(sender.bottom + 20)
                    self.currentButton = sender
                }
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.weightButtonBottomConstraint.constant = 40
                    
                    self.updateRulerView(nil)
                    sender.tag %= 100
                    self.view.layoutIfNeeded()
                    self.currentButton = UIButton()
                }
            }
        case 2:
            if sender.tag < 100 {
                UIView.animate(withDuration: 0.25) {
                    self.foodButtonBottomConstrain.constant = 70 + 40
                    sender.tag += 100
                    
                    self.weightButtonBottomConstraint.constant = 40
                    self.weightButton.tag %= 100
                    
                    self.bithButtonBottomConstraint.constant = 40
                    self.birthButton.tag %= 100

                    self.view.layoutIfNeeded()
                    self.updateRulerView(sender.bottom + 20)
                    self.currentButton = sender
                }
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.foodButtonBottomConstrain.constant = 40
                    
                    self.updateRulerView(nil)
                    sender.tag %= 100
                    self.view.layoutIfNeeded()
                    self.currentButton = UIButton()
                }
            }
        default:
            break
        }
    }
}
