//
//  PJPetCreateNameViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/5/12.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJPetCreateNameViewController: UIViewController, PJBaseViewControllerDelegate {
    var petType: PJPet.PetType = .dog
    var viewModel: ViewModel?
    
    var complateHandler: ((String) -> Void)?
    
    @IBOutlet private weak var tipsTitleLabel: UILabel!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet weak var bottomTipsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        initBaseView()
        backButtonTapped(backSel: .back, imageName: nil)
        
        doneButton.addTarget(self, action: .done, for: .touchUpInside)
        
        nameTextField.becomeFirstResponder()
        nameTextField.layer.cornerRadius = nameTextField.pj_height / 2
        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        nameTextField.leftViewMode = .always;
        
        switch petType {
        case .cat:
            titleString = "添加猫咪"
            tipsTitleLabel.text = "填写猫咪名字"
            nameTextField.placeholder = "请输入猫咪名字"
        case .dog:
            titleString = "添加狗狗"
            tipsTitleLabel.text = "填写狗狗名字"
            nameTextField.placeholder = "请输入狗狗名字"
        }
        
        if viewModel != nil {
            tipsTitleLabel.text = viewModel!.title
            nameTextField.placeholder = viewModel?.placeholder
            bottomTipsLabel.text = viewModel?.bottomString
            doneButton.setTitle(viewModel?.doneString, for: .normal)
        }
        
        NotificationCenter.default.addObserver(self, selector: .keyboardFrame, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

}

private extension Selector {
    static let keyboardFrame = #selector(PJPetCreateNameViewController.keyBoardFrameChange(_:))
    static let back = #selector(PJPetCreateNameViewController.back)
    static let done = #selector(PJPetCreateNameViewController.done)
}

extension PJPetCreateNameViewController {
    @objc
    fileprivate func back() {
        if viewModel != nil {
            guard nameTextField.text != nil else { return }
            complateHandler?("其它")
            
            var vcs = self.navigationController?.viewControllers
            vcs!.remove(at: vcs!.count - 2)
            self.navigationController?.viewControllers = vcs!
        }
        
        popBack()
    }
    
    @objc
    fileprivate func done() {
        guard nameTextField.text?.count != 0 else {
            PJHUD.shared.showError(view: view, text: "请重填信息")
            return
        }
        
        if viewModel != nil {
            // 提交
        } else {
            var pet = PJPet.Pet()
            pet.nick_name = nameTextField.text!
            pet.pet_type = petType
            print(nameTextField.text!)
            
            let vc = UIStoryboard(name: "PJPetCreateAvatarViewController", bundle: nil).instantiateViewController(withIdentifier: "PJPetCreateAvatarViewController") as! PJPetCreateAvatarViewController
            vc.pet = pet
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc
    fileprivate func keyBoardFrameChange(_ notification: Notification){
        let info = notification.userInfo
        let kbRect = (info?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let offsetY = kbRect.origin.y - view.pj_width
        UIView.animate(withDuration: 0.25) {
            if offsetY == 0 {
                self.doneButton.bottom = self.view.pj_height
            }else{
                self.doneButton.bottom = offsetY
            }
        }
    }
}


extension PJPetCreateNameViewController {
    struct ViewModel {
        var title: String
        var placeholder: String
        var bottomString: String
        var doneString: String
    }
}
