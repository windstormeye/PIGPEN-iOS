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
                self.petTypes.insert(self.collectionView!.viewModels[index].pet_type)
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
                break
            case 2:
                if self.petTypes.contains(.cat) {
                    
                    var pets = [PJPet.Pet]()
                    for item in self.collectionView!.selectedPets {
                        pets.append((self.collectionView?.viewModels[item])!)
                    }
                    let vc = PJCatPlayHomeViewController(viewModels: pets)
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    
                    let vc = PJDogPlayViewController()
                    
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            default: break
            }
        }
        
        circleOfDots()
        
        initData()
    }
    
    private func initData() {
        PJUser.shared.pets(complateHandler: {
            self.collectionView!.viewModels = $0
        }) {
            print($0.errorMsg)
        }
    }
    
    func circleOfDots() {
        let score = CGFloat(8.5)
        let startAngle = -CGFloat.pi * 0.5
        let endAngle = -(CGFloat.pi * 2 * 0.1 * score) + startAngle
        
        let circlePath1 = UIBezierPath(arcCenter: CGPoint(x: 0,y: 0), radius: CGFloat(22.5), startAngle: endAngle, endAngle: startAngle, clockwise: false)
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.path = circlePath1.cgPath
        shapeLayer1.position = CGPoint(x: 200 ,y: view.bounds.midY + 100)
        //change the fill color
        shapeLayer1.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        shapeLayer1.strokeColor = UIColor.lightGray.cgColor
        //you can change the line width
        shapeLayer1.lineWidth = 4
        shapeLayer1.lineDashPattern = [1, 6]
        shapeLayer1.lineCap = CAShapeLayerLineCap.round
        self.view.layer.addSublayer(shapeLayer1)
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 0,y: 0), radius: CGFloat(22.5), startAngle: startAngle, endAngle: endAngle, clockwise: false)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.position = CGPoint(x: 200 ,y: view.bounds.midY + 100)
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = PJRGB(255, 85, 67).cgColor
        //you can change the line width
        shapeLayer.lineWidth = 4
        shapeLayer.lineDashPattern = [1, 6]
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        self.view.layer.addSublayer(shapeLayer)
    }
}
