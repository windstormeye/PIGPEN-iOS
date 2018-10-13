//
//  PJUserDateilsRealPetColletionView.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/8.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

protocol PJUserDateilsRealPetColletionViewDelegate {
    func PJUserDateilsRealPetColletionViewDidSelectedIndex(collectionView: PJUserDateilsRealPetColletionView, index: Int)
}

extension PJUserDateilsRealPetColletionViewDelegate {
    func PJUserDateilsRealPetColletionViewDidSelectedIndex(collectionView: PJUserDateilsRealPetColletionView, index: Int) {}
}

class PJUserDateilsRealPetColletionView: UICollectionView,
UICollectionViewDelegate, UICollectionViewDataSource {
    static let cellIdentifier = "PJUserDateilsRealPetColletionViewCell"
    
    var viewDelegate: PJUserDateilsRealPetColletionViewDelegate?
    var dataArray = [RealPet]()
    
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
                 forCellWithReuseIdentifier: PJUserDateilsRealPetColletionView.cellIdentifier)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if dataArray.count == 0 {
            return 1
        } else {
            return dataArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PJUserDateilsRealPetColletionView.cellIdentifier, for: indexPath)
        let count = dataArray.count - 1
        if indexPath.row == (count < 0 ? 0 : count) {
            let cellImageView = UIImageView(frame: CGRect(x: 0, y: 0,
                                                          width: cell.width,
                                                          height: cell.height))
            cellImageView.image = UIImage(named: "user_details_addPet")
            cell.contentView.addSubview(cellImageView)
        } else {
            let cellImageView = UIImageView(frame: CGRect(x: 0, y: 0,
                                                          width: cell.width,
                                                          height: cell.height))
            cellImageView.image = UIImage(named: "pet_avatar")
            cell.contentView.addSubview(cellImageView)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        viewDelegate?.PJUserDateilsRealPetColletionViewDidSelectedIndex(collectionView: self,
                                                                        index: indexPath.row)
    }
}
