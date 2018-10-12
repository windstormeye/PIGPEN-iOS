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

class PJCreateRealPetViewController: PJBaseViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var birthButton: UITextField!
    @IBOutlet weak var weightButton: UITextField!
    @IBOutlet weak var pppTextField: UITextField!
    @IBOutlet weak var loveButton: UITextField!
    @IBOutlet weak var relationshipButton: UITextField!
    @IBOutlet weak var okButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        navigationItem.title = "添加宠物资料"
        backButtonTapped(backSel: .back)
        isHiddenBarBottomLineView = false
        
        okButton.backgroundColor = UIColor.unFocusColor()
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
}
