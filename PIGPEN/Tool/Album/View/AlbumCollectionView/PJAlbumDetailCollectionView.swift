//
//  PJAlbumDetailCollectionView.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/12/2.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJAlbumDetailCollectionView: UICollectionView {
    // MARK: - Public Properties
    var cellModel: [PJAlbumDetailCollectionViewCell.cellModel]?
    
    // MARK: - Private Properties
    private static let cellIndetifier = "PJAlbumDetailCollectionViewCell"
    
    // MAKR: - Public Methonds
    // MARK: - Life Cycle
    override init(frame: CGRect, collectionViewLayout
        layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Private Methods
    private func initView() {
        delegate = self
        dataSource = self
        
        register(UINib(nibName :"PJAlbumDetailCollectionViewCell", bundle: nil),
                 forCellWithReuseIdentifier: PJAlbumDetailCollectionView.cellIndetifier)
    }

}

extension PJAlbumDetailCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let cellModel = cellModel else { return 0 }
        return cellModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellModel = cellModel else { return UICollectionViewCell() }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PJAlbumDetailCollectionView.cellIndetifier,
                                                      for: indexPath) as! PJAlbumDetailCollectionViewCell
        cell.setModel(model: cellModel[indexPath.row])
        return cell
    }
    
    
}

// TODO: 怎么优雅的给 `UICollectionView` 写 Layout
//extension PJAlbumDetailCollectionView: UICollectionViewFlowLayout {
//
//}
