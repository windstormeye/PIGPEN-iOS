//
//  PJPlayViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/25.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJPlayViewController: UIViewController, PJBaseViewControllerDelegate {

    private var collectionView: PJPetPlayCollectionView?
    private var petTypes = Set<PJPet.PetType>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        initBaseView()
        titleString = "娱乐圈"
        
        view.backgroundColor = .white
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        let itemW = (view.pj_width - 30 - 10) / 2
        let innerW = CGFloat(10)
        collectionViewLayout.itemSize = CGSize(width: itemW , height: itemW * 0.665)
        collectionViewLayout.minimumLineSpacing = innerW
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.footerReferenceSize = CGSize(width: view.pj_width, height: 77)
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 40, right: 15)
        
        collectionView = PJPetPlayCollectionView(frame: CGRect(x: 0, y: 0, width: view.pj_width, height: view.pj_height - navigationBarHeight), collectionViewLayout: collectionViewLayout)
        view.addSubview(collectionView!)
        
        collectionView?.cellSelected = {
            guard $0.count != 0 else {
                self.collectionView?.footerView.unHightlight()
                return
            }
            
            self.petTypes.removeAll()
            for index in $0 {
                self.petTypes.insert(self.collectionView!.viewModels[index].pet.pet_type)
            }
            
            // 猫
            if !self.petTypes.contains(.dog) {
                // 可同 吃喝玩
                self.collectionView?.footerView.allCats()
                return
            }
            
            if !self.petTypes.contains(.cat) {
                // 都是狗
                if $0.count > 1 {
                    // 可同 喝玩
                    self.collectionView?.footerView.allDogs()
                    return
                }
                // 一只狗
                self.collectionView?.footerView.dog()
                return
            }
            
            // 猫狗。可同 喝
            self.collectionView?.footerView.catAndDog()
        }
        
        collectionView?.footerSelected = {
            switch $0 {
            case 0:
                break
            case 1:
                var pets = [PJPet.Pet]()
                for item in self.collectionView!.selectedPets {
                    pets.append((self.collectionView?.viewModels[item].pet)!)
                }
                let vc = PJPetDrinkViewController(viewModels: pets)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case 2:
                if self.petTypes.contains(.cat) && !self.petTypes.contains(.dog) {
                    var pets = [PJPet.Pet]()
                    for item in self.collectionView!.selectedPets {
                        pets.append((self.collectionView?.viewModels[item].pet)!)
                    }
                    let vc = PJCatPlayHomeViewController(viewModels: pets)
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                if self.petTypes.contains(.dog) && !self.petTypes.contains(.cat) {
                    var viewModels = [PJPet.Pet]()
                    for item in self.collectionView!.selectedPets {
                        viewModels.append((self.collectionView?.viewModels[item].pet)!)
                    }
                    
                    let vc = PJDogPlayHomeViewController(viewModels: viewModels)
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            default: break
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if collectionView != nil {
            initData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        collectionView?.unHighlightFooterView()
    }
    
    private func initData() {
        PJPet.shared.getPlayData(complateHandler: {
            self.collectionView!.viewModels = $0
        }) {
            PJHUD.shared.show(view: self.view, text: $0.errorMsg)
        }
    }
}
