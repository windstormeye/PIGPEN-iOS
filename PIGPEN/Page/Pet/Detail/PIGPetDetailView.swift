//
//  PIGPetDetailView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/21.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PIGPetDetailViewController: UIViewController, PJBaseViewControllerDelegate {
    private var pet = PJPet.Pet()
    private var avatarImage = UIImage()
    private var collectionView = PIGAroundPetCollectionView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(pet: PJPet.Pet, avatarImage: UIImage) {
        self.init(nibName: nil, bundle: nil)
        self.pet = pet
        self.avatarImage = avatarImage
        initView()
    }
    
    private func initView() {
        view.backgroundColor = .white
        
        initBaseView()
        titleString = pet.nick_name
        backButtonTapped(backSel: .back)
        rightBarButtonItem(imageName: "share", rightSel: .share)
        
        let avatarImageView = UIImageView(frame: CGRect(x: 10, y: 0, width: view.pj_width - 20, height: view.pj_width - 20))
        avatarImageView.image = self.avatarImage
        avatarImageView.layer.cornerRadius = 5
        avatarImageView.layer.masksToBounds = true
        
        let infoView = PIGPetDetailInfoView.newInstance()
        infoView.frame = CGRect(x: 0, y: avatarImageView.bottom, width: view.pj_width, height: 50)
        
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.pj_width, height: infoView.bottom))
        headerView.addSubview(avatarImageView)
        headerView.addSubview(infoView)
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        let itemCount: CGFloat = 3
        let itemW = view.pj_width / itemCount - 2
        collectionViewLayout.itemSize = CGSize(width: itemW, height: itemW)
        collectionViewLayout.minimumLineSpacing = 0.5
        collectionViewLayout.minimumInteritemSpacing = 0.5
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        
        collectionView = PIGAroundPetCollectionView(frame: CGRect(x: 0, y: navigationBarHeight, width: view.pj_width, height: view.pj_height - navigationBarHeight), collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.itemSelected = {
            let vc = PIGPetDetailViewController(pet: $0, avatarImage: $1)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        collectionView.addSubview(headerView)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
}

extension PIGPetDetailViewController {
    @objc
    fileprivate func back() {
        popBack()
    }
    
    @objc
    fileprivate func share() {
        
    }
}

private extension Selector {
    static let back = #selector(PIGPetDetailViewController.back)
    static let share = #selector(PIGPetDetailViewController.share)
}
