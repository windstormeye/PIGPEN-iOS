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

class PJUserDateilsRealPetColletionView: UICollectionView {
    static let cellIdentifier = "PJUserDateilsRealPetColletionViewCell"
    
    var viewDelegate: PJUserDateilsRealPetColletionViewDelegate?
    var dataArray = [PJRealPet.RealPetModel]()
    
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
}

extension PJUserDateilsRealPetColletionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return dataArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PJUserDateilsRealPetColletionView.cellIdentifier, for: indexPath)
        if indexPath.row == dataArray.count {
            let cellImageView = UIImageView(frame: CGRect(x: 0, y: 0,
                                                          width: cell.pj_width,
                                                          height: cell.pj_height))
            cellImageView.image = UIImage(named: "user_details_addPet")
            cell.addSubview(cellImageView)
//            cell.contentView.addSubview(cellImageView)
        } else {
            let cellImageView = UIImageView(frame: CGRect(x: 0, y: 0,
                                                          width: cell.pj_width,
                                                          height: cell.pj_height))
            let cellModel = dataArray[indexPath.row]
            // TODO: 需要设置占位图
            cellImageView.kf.setImage(with: URL(string: cellModel.avatar_url!))
            cellImageView.layer.cornerRadius = 40
            cellImageView.clipsToBounds = true
            cell.addSubview(cellImageView)
//            cell.contentView.addSubview(cellImageView)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        viewDelegate?.PJUserDateilsRealPetColletionViewDidSelectedIndex(collectionView: self,
                                                                        index: indexPath.row)
    }
}
