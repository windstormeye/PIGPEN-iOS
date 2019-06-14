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
            print($0)
            self.collectionView?.footerView.foodImageView.isHighlighted = true
        }
        
//        let collectionView = PJPlayCollectionView(frame: CGRect(x: 0, y: 0, width: view.pj_width, height: view.pj_height - navigationBarHeight))
//        view.addSubview(collectionView)
//        collectionView.selectedActivity = {
//            switch $0 {
//            case 0:
//                break
//            case 1:
//                break
//            case 2:
////                let vc = PJCatPlayViewController()
//                let vc = PJDogPlayViewController()
//                vc.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(vc, animated: true)
//            default:
//                break
//            }
//        }
        
        initData()
    }
    
    private func initData() {
        PJUser.shared.pets(complateHandler: {
            self.collectionView!.viewModels = $0
        }) {
            print($0.errorMsg)
        }
    }
}
