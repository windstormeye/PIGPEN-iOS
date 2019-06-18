//
//  PJPetPlayCollectionView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/14.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJPetPlayCollectionView: UICollectionView {
    
    var cellSelected: (([Int]) -> Void)?
    var footerSelected: ((Int) -> Void)?

    var viewModels = [PJPlayCellView.ViewModel]() {
        didSet { reloadData() }
    }
    var selectedPets = [Int]()
    var footerView = PJPetPlayCollectionFooterView()
    
    // MARK: - init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        backgroundColor = .white
        
        dataSource = self
        delegate = self
        allowsMultipleSelection = true
        
        register(UINib(nibName: "PJPlayCellView", bundle: nil),
                 forCellWithReuseIdentifier: "PJPlayCellView")
        register(UINib(nibName: "PJPetPlayCollectionFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "PJPetPlayCollectionFooterView")
    }
}

extension PJPetPlayCollectionView {
    func unHighlightFooterView() {
        footerView.unHightlight()
    }
}

extension PJPetPlayCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PJPlayCellView", for: indexPath) as! PJPlayCellView
        var viewModel = PJPlayCellView.ViewModel()
        viewModel.pet = viewModels[indexPath.row].pet
        viewModel.score = viewModels[indexPath.row].score
        cell.viewModel = viewModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PJPetPlayCollectionFooterView", for: indexPath) as! PJPetPlayCollectionFooterView
            self.footerView = footerView
            footerView.itemSelected = {
                self.footerSelected?($0)
            }
            return footerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
}

extension PJPetPlayCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPets = collectionView.indexPathsForSelectedItems!.map({ (index) -> Int in
            return index.row
        })
        cellSelected?(selectedPets)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedPets = collectionView.indexPathsForSelectedItems!.map({ (index) -> Int in
            return index.row
        })
        cellSelected?(selectedPets)
    }
}
