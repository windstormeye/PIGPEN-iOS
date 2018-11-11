//
//  PJCreateRealPetViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/12.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let back = #selector(PJCreateRealPetViewController.back)
}

class PJCreateRealPetViewController: PJBaseViewController, UITextFieldDelegate {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    // tag = 1000
    @IBOutlet weak var breedTextField: UITextField!
    // tag = 1001
    @IBOutlet weak var birthTextField: UITextField!
    // tag = 1002
    @IBOutlet weak var weightTextField: UITextField!
    // tag = 1003
    @IBOutlet weak var pppTextField: UITextField!
    // tag = 1004
    @IBOutlet weak var loveTextField: UITextField!
    // tag = 1005
    @IBOutlet weak var relationshipTextField: UITextField!
    
    var tempBreedModel: RealPetBreedModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        navigationItem.title = "添加宠物资料"
        backButtonTapped(backSel: .back)
        isHiddenBarBottomLineView = false
        
        okButton.backgroundColor = UIColor.unFocusColor()
        
        breedTextField.delegate = self
        pppTextField.delegate = self
        breedTextField.delegate = self
        birthTextField.delegate = self
        relationshipTextField.delegate = self
        weightTextField.delegate = self
        loveTextField.delegate = self
    }
    
    // MARK: Action
    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func femaleButtonTapped(_ sender: UIButton) {
        femaleButton.isSelected = !femaleButton.isSelected
        maleButton.isSelected = false
    }
    
    @IBAction func maleButtonTapped(_ sender: UIButton) {
        maleButton.isSelected = !maleButton.isSelected
        femaleButton.isSelected = false
    }
    
    @IBAction func okButtonTapped(_ sender: UIButton) {
        
    }
    
    // MARK: - Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard textField.tag >= 1000 else {
            return true
        }
        
        switch textField.tag {
        case 1000:
            let vc = PJBreedsViewController()
            vc.selectComplation = { [weak self] model in
                if let `self` = self {
                    self.breedTextField.text = model.zh_name ?? ""
                    self.tempBreedModel = model
                }
            }
            if tempBreedModel != nil {
                vc.selectedModel = tempBreedModel
            }
            navigationController?.pushViewController(vc,
                                                     animated: true)
        case 1001:
            PJPickerView.showPickerView(viewModel: { (viewModel) in
                viewModel.titleString = "猫咪的生日"
                viewModel.pickerType = .time
            }) { [weak self] finalString in
                if let `self` = self {
                    self.birthTextField.text = finalString
                }
            }
        case 1002:
            PJPickerView.showPickerView(viewModel: { (viewModel) in
                viewModel.titleString = "猫咪体重"
                var weightArray = [String]()
                for item in 0...100 {
                    weightArray.append("\(item)")
                }
                var o_weightArray = [String]()
                for item in 0..<10 {
                    o_weightArray.append("\(item)")
                }
                viewModel.dataArray = [weightArray, o_weightArray, ["kg"]]
                viewModel.pickerType = .custom
            }) { [weak self] finalString in
                if let `self` = self {
                    guard finalString != "00" else {
                        return
                    }
                    var finalString = finalString
                    if (finalString[finalString.startIndex] == "0") {
                        finalString.remove(at: finalString.startIndex)
                    }
                    self.weightTextField.text = finalString + "00g"
                }
            }
        case 1003:
            PJPickerView.showPickerView(viewModel: { (viewModel) in
                viewModel.titleString = "绝育情况"
                viewModel.pickerType = .custom
                viewModel.dataArray = [["已绝育", "未绝育"]]
            }) { [weak self] finalString in
                if let `self` = self {
                    self.pppTextField.text = finalString
                }
            }
        case 1004:
            PJPickerView.showPickerView(viewModel: { (viewModel) in
                viewModel.titleString = "感情状态"
                viewModel.pickerType = .custom
                viewModel.dataArray = [["单身", "约会中", "已婚"]]
            }) { [weak self] finalString in
                if let `self` = self {
                    self.loveTextField.text = finalString
                }
            }
        case 1005:
            PJPickerView.showPickerView(viewModel: { (viewModel) in
                viewModel.titleString = "猫咪与您的关系"
                viewModel.pickerType = .custom
                viewModel.dataArray = [["我是妈咪", "我是爸比", "我是爷爷", "我是奶奶",
                                        "我是姐姐", "我是哥哥", "我是弟弟", "我是妹妹",
                                        "我是干爸", "我是干妈", "我是叔叔", "我是阿姨",]]
            }) { [weak self] finalString in
                if let `self` = self {
                    self.relationshipTextField.text = finalString
                }
            }
        default: break
        }
        
        return false
    }
}
