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
    
    private var moreFoodCheckButton = UIButton()
    private var currentButton = UIButton()
    private var birthView = PJPetCreateBirthView.newInstance()
    private var rulerView = PJRulerPickerView()
    
    private var btns = [UIButton]()
    private var originBtns = [UIButton]()
    
    private var birthViewSelectedIndex = 0
    // 生日开始年份
    private var startYear = 1990
    // 体重上限（kg）
    private let maxWeight = 100
    // 喂食量上限（g）
    private var maxFood = 5000
    private var daysArray = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    private var birthButtonTop: CGFloat = 0
    private var weightButtonTop: CGFloat = 0
    private var foodButtonTop: CGFloat = 0
    
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
            case 0:
                switch self.birthViewSelectedIndex {
                case 0:
                    self.birthView.setYear(count: $0)
                case 1:
                    self.birthView.setMonth(count: $0)
                case 2:
                    self.birthView.setDay(count: $0)
                default:
                    break
                }
            case 1:
                self.currentButton.setTitle("\($0)kg", for: .normal)
                self.currentButton.setTitleColor(.black, for: .normal)
            case 2:
                self.currentButton.setTitle("\($0)g", for: .normal)
                self.currentButton.setTitleColor(.black, for: .normal)
            default:
                break
            }
            
            let yearString = "\(self.birthView.currentYear)年"
            var monthString = ""
            if self.birthView.currentMonth != -1 {
                monthString = "\(self.birthView.currentMonth)月"
            }
            var dayString = ""
            if self.birthView.currentDay != -1 {
                dayString = "\(self.birthView.currentDay)日"
            }
            
            let finalString = yearString + monthString + dayString
            self.birthButton.setTitle(finalString, for: .normal)
            self.birthButton.setTitleColor(.black, for: .normal)
        }
        
        birthView.pj_width = view.pj_width
        birthView.pj_height = 50
        birthView.centerX = view.centerX
        birthView.alpha = 0
        birthView.isHidden = true
        view.addSubview(birthView)
        birthView.yearSelected = {
            self.birthViewSelectedIndex = 0
            let date = Date()
            let calendar = Calendar.current
            
            let year = calendar.component(.year, from: date)
            self.rulerView.pickCount = year - 1980 + 1
        }
        birthView.monthSelected = {
            self.birthViewSelectedIndex = 1
            self.rulerView.pickCount = 12
            
            
        }
        birthView.daySelected = {
            self.birthViewSelectedIndex = 2
            
            let year = self.birthView.currentYear
            if year % 400 == 0 || year % 100 != 0 && year % 4 == 0 {
                self.daysArray[2] = 29
            } else {
                self.daysArray[2] = 28
            }
            
            self.rulerView.pickCount = self.daysArray[self.birthView.currentMonth]
        }
        
        moreFoodCheckButton.pj_width = 100
        moreFoodCheckButton.pj_height = 30
        moreFoodCheckButton.centerX = view.centerX
        moreFoodCheckButton.setTitleColor(.black, for: .normal)
        moreFoodCheckButton.setTitle("每日进食量参考", for: .normal)
        moreFoodCheckButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        moreFoodCheckButton.alpha = 0
        moreFoodCheckButton.isHidden = true
        moreFoodCheckButton.addTarget(self, action: .moreFood, for: .touchUpInside)
        view.addSubview(moreFoodCheckButton)
    }
    
    private func initData() {
        
    }
}

private extension Selector {
    static let back = #selector(PJCreatePetSelfDetailsViewController.back)
    static let done = #selector(PJCreatePetSelfDetailsViewController.done)
    static let btnTapper = #selector(PJCreatePetSelfDetailsViewController.btnTapper(sender:))
    static let moreFood = #selector(PJCreatePetSelfDetailsViewController.moreFood)
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
    fileprivate func moreFood() {
        let vc = UIStoryboard(name: "PJPetCreateDogFoodViewController", bundle: nil).instantiateViewController(withIdentifier: "PJPetCreateDogFoodViewController")
        navigationController?.pushViewController(vc, animated: true)
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
                    UIView.animate(withDuration: 0.25, animations: {
                        self.rulerView.alpha = 1
                    }, completion: { (finished) in
                        if finished {
                            switch self.currentButton.tag - 100 {
                            case 0:
                                self.birthView.isHidden = false
                                self.birthView.alpha = 1
                                self.birthView.top = self.rulerView.top - 10
                                self.rulerView.top = self.birthView.bottom
                            case 1:
                                break
                            case 2:
                                self.moreFoodCheckButton.isHidden = false
                                self.moreFoodCheckButton.alpha = 1
                                self.moreFoodCheckButton.top = self.rulerView.bottom + 10
                            default:
                                break
                            }
                        }
                    })
                }
            }
        }
    }
    
    @objc
    fileprivate func btnTapper(sender: UIButton) {
        self.currentButton = sender
        
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
                    
                    self.moreFoodCheckButton.isHidden = true
                    self.moreFoodCheckButton.alpha = 0
                }
            } else {
                self.currentButton = UIButton()

                UIView.animate(withDuration: 0.25) {
                    self.bithButtonBottomConstraint.constant = 40
                    
                    self.updateRulerView(nil)
                    sender.tag %= 100
                    self.view.layoutIfNeeded()
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
                    self.rulerView.pickCount = 101
                    self.updateRulerView(sender.bottom + 20)
                    
                    self.moreFoodCheckButton.isHidden = true
                    self.moreFoodCheckButton.alpha = 0
                    
                    self.birthView.isHidden = true
                    self.birthView.alpha = 0
                }
            } else {
                self.currentButton = UIButton()

                UIView.animate(withDuration: 0.25) {
                    self.weightButtonBottomConstraint.constant = 40
                    
                    self.updateRulerView(nil)
                    sender.tag %= 100
                    self.view.layoutIfNeeded()
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
                    self.rulerView.pickCount = 5001
                    self.updateRulerView(sender.bottom + 20)
                    
                    self.birthView.isHidden = true
                    self.birthView.alpha = 0
                }
            } else {
                self.currentButton = UIButton()

                UIView.animate(withDuration: 0.25) {
                    self.foodButtonBottomConstrain.constant = 40
                    
                    self.updateRulerView(nil)
                    sender.tag %= 100
                    self.view.layoutIfNeeded()
                }
            }
        default:
            break
        }
    }
}
