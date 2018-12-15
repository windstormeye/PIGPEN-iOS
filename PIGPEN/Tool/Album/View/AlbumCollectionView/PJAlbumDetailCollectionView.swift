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
    var collectionModel: [PJAlbumDataManager.Photo]?
    
    // MARK: - Private Properties
    private static let cellIndetifier = "PJAlbumDetailCollectionViewCell"
    
    // MAKR: - Public Methonds
    // MARK: - Life Cycle
    override init(frame: CGRect, collectionViewLayout
        layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initView()
    }
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, collectionViewLayout: PJAlbumCollectiionFlowLayout())
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Private Methods
    private func initView() {
        delegate = self
        dataSource = self
        backgroundColor = .clear
        
        register(UINib(nibName :"PJAlbumDetailCollectionViewCell", bundle: nil),
                 forCellWithReuseIdentifier: PJAlbumDetailCollectionView.cellIndetifier)
    }

}

extension PJAlbumDetailCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let collectionModel = collectionModel else { return 0 }
        return collectionModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionModel = collectionModel else { return UICollectionViewCell() }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PJAlbumDetailCollectionView.cellIndetifier,
                                                      for: indexPath) as! PJAlbumDetailCollectionViewCell
        let cellModel = PJAlbumDetailCollectionViewCell.cellModel(avatarImage: collectionModel[indexPath.row].photoImage ?? UIImage())
        cell.setModel(model: cellModel)
        return cell
    }
    
    
}
