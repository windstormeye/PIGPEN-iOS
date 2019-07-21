//
//  PIGAroundPetCollectionView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/13.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PIGAroundPetCollectionView: UICollectionView {

    var itemSelected: ((PJPet.Pet, UIImage) -> Void)?
    var viewModels = [PJPet.Around]() {
        didSet {
            reloadData()
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: CGRect(), collectionViewLayout: UICollectionViewLayout())
    }
    
    private func initView() {
        delegate = self
        dataSource = self
        
        register(UINib(nibName: "PIGAroundPetCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PIGAroundPetCollectionViewCell")
    }

}

extension PIGAroundPetCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PIGAroundPetCollectionViewCell
        itemSelected?(viewModels[indexPath.row].pet, cell.avatarImageView.image!)
    }
}

extension PIGAroundPetCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PIGAroundPetCollectionViewCell", for: indexPath) as! PIGAroundPetCollectionViewCell
        cell.viewModel = viewModels[indexPath.row]
        return cell
    }
    
    
}
