//
//  PJUserDetailsVirtualPetCollectionView.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/12.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

protocol PJUserDateilsVirtualPetCollectionViewDelegate {
    func PJUserDateilsVirtualPetColletionViewDidSelectedIndex(collectionView: PJUserDetailsVirtualPetCollectionView, index: Int)
}

extension PJUserDateilsVirtualPetCollectionViewDelegate {
    func PJUserDateilsVirtualPetColletionViewDidSelectedIndex(collectionView: PJUserDetailsVirtualPetCollectionView, index: Int) {}
}

class PJUserDetailsVirtualPetCollectionView: UICollectionView,
UICollectionViewDelegate, UICollectionViewDataSource {

    static let cellIdentifier = "PJUserDateilsVirtualPetColletionViewCell"
    
    var viewDelegate: PJUserDateilsVirtualPetCollectionViewDelegate?
    var dataArray = [Pet]()
    
    override init(frame: CGRect,
                  collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame,
                   collectionViewLayout: layout)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initView() {
        backgroundColor = .white
        showsHorizontalScrollIndicator = false
        
        delegate = self
        dataSource = self
        
        register(UICollectionViewCell.self,
                 forCellWithReuseIdentifier: PJUserDetailsVirtualPetCollectionView.cellIdentifier)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PJUserDetailsVirtualPetCollectionView.cellIdentifier, for: indexPath)
        
        if dataArray.count != 0 {
            let cellImageView = UIImageView(frame: CGRect(x: 0, y: 0,
                                                          width: cell.width,
                                                          height: cell.height))
            cellImageView.image = UIImage(named: "pet_avatar")
            cell.contentView.addSubview(cellImageView)
        } else {
            let cellImageView = UIImageView(frame: CGRect(x: 0, y: 0,
                                                          width: cell.width,
                                                          height: cell.height))
            cellImageView.image = UIImage(named: "user_details_addPet")
            cell.contentView.addSubview(cellImageView)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        viewDelegate?.PJUserDateilsVirtualPetColletionViewDidSelectedIndex(collectionView: self,
                                                                        index: indexPath.row)
    }

}
