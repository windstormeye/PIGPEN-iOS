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
    // 关系代码 -1 黑户
    var relation_code = 0
    
    private var breed = PJPet.PetBreedModel(id: -1, zh_name: "")
    
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
        
        breedButton.addTarget(self, action: .choiceBreeds, for: .touchUpInside)
        relationButton.addTarget(self, action: .choiceRelation, for: .touchUpInside)
        
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
    static let choiceBreeds = #selector(PJCreatePetDetailsViewController.choiceBreeds)
    static let choiceRelation = #selector(PJCreatePetDetailsViewController.choiceRelation)
}

extension PJCreatePetDetailsViewController {
    @objc
    fileprivate func back() {
        popBack()
    }
    
    @objc
    fileprivate func choiceBreeds() {
        let vc = PJPetCreateBreedsViewController()
        vc.petType = pet.pet_type
        vc.selectedModel = breed
        navigationController?.pushViewController(vc, animated: true)
        
        vc.selectComplation = {
            self.breed = $0
            self.pet.breed_type = $0.zh_name
            self.breedButton.setTitle($0.zh_name, for: .normal)
            self.breedButton.isSelected = true
        }
    }
    
    @objc
    fileprivate func choiceRelation() {
        let vc = PJPetCreateRelationViewController()
        vc.selectedIndex = relation_code
        vc.selected = {
            self.relation_code = $0
            if $1 == "其它" {
                self.relationButton.setTitle($1, for: .normal)
            } else {
                self.relationButton.setTitle("我是狗狗的" + $1, for: .normal)
            }
            
            self.relationButton.isSelected = true
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
