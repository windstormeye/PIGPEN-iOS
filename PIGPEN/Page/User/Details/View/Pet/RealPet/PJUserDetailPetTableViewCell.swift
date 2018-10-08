//
//  PJUserDetailPetTableViewCell.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/5.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJUserDetailPetTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initView() {
        
        let petArray = [Pet(), Pet(), Pet(), Pet()]
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        let itemW = 80
        collectionViewLayout.itemSize = CGSize(width: itemW , height: itemW)
        collectionViewLayout.minimumLineSpacing = 30
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 10,
                                                              bottom: 0, right: 0)

        let collectionViewRect = CGRect(x: 0, y: 0, width: PJSCREEN_WIDTH, height: 100)
        let avatarCollectionView = PJUserDateilsRealPetColletionView(frame: collectionViewRect,
                                                                    collectionViewLayout: collectionViewLayout)
        avatarCollectionView.alwaysBounceHorizontal = true
        contentView.addSubview(avatarCollectionView)
        
        avatarCollectionView.dataArray = petArray
        avatarCollectionView.reloadData()
    }
}
