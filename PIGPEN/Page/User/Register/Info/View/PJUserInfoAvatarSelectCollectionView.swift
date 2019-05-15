//
//  PJUserInfoAvatarSelectCollectionView.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/1.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit


protocol PJUserInfoAvatarSelectCollectionViewDelegate: class {
    func PJUserInfoAvatarSelectCollectionViewDidSelected(collectionView: PJUserInfoAvatarSelectCollectionView,
                                                         indexPath: IndexPath)
}

extension PJUserInfoAvatarSelectCollectionViewDelegate {
    func PJUserInfoAvatarSelectCollectionViewDidSelected(collectionView: PJUserInfoAvatarSelectCollectionView,
                                                         indexPath: IndexPath) {}
}

class PJUserInfoAvatarSelectCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    static let cellIdentifierString = "PJUserInfoAvatarSelectCollectionViewCell"
    let collectionViewCellCount = 6
    
    var viewDelegate: PJUserInfoAvatarSelectCollectionViewDelegate?
    
    
    // MRAK: life cycle
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    private func initView() {
        backgroundColor = .clear
        
        delegate = self
        dataSource = self
        
        register(UICollectionViewCell.self,
                 forCellWithReuseIdentifier: PJUserInfoAvatarSelectCollectionView.cellIdentifierString)
    }
    
    // MARK: delegate

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PJUserInfoAvatarSelectCollectionView.cellIdentifierString, for: indexPath)
        let cellImage = UIImage(named: "0")
        cell.backgroundView = UIImageView(image: cellImage!)
        let backImage = UIImage(named: "user_info_avatar_selected")
        cell.selectedBackgroundView = UIImageView(image: backImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewDelegate?.PJUserInfoAvatarSelectCollectionViewDidSelected(collectionView: self,
                                                                      indexPath: indexPath)
    }

}
