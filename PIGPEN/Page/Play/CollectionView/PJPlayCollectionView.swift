//
//  PJPlayCollectionView.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/6/11.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit
import CollectionKit

class PJPlayCollectionView: UIView {
    
    let viewModels = [PJPet(), PJPet(), PJPet(), PJPet(), PJPet()]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        let margin = CGFloat(15)
        let itemSizeW = (pj_width - margin * 2 - 10) / 2
        
        let layout = FlowLayout(lineSpacing: 10, interitemSpacing: 10, justifyContent: .start, alignItems: .start, alignContent: .start).inset(by: UIEdgeInsets(top: 10, left: margin, bottom: 0, right: 0))
        
        let sizeSource = ClosureSizeSource { (index: Int, data: PJPet, size: CGSize) -> CGSize in
            return CGSize(width: itemSizeW, height: itemSizeW * 0.655)
        }
        
        let viewSource = ClosureViewSource(viewGenerator: { (viewModel: PJPet, index: Int) -> PJPlayCellView in
            let cell = PJPlayCellView.newInstance()
            return cell
        }) { (cell: PJPlayCellView, viewModel: PJPet, index) in
            
        }
        
        let provider = BasicProvider(identifier: nil,
                                     dataSource: viewModels,
                                     viewSource: viewSource,
                                     sizeSource: sizeSource,
                                     layout: layout,
                                     animator: nil)
        
        let collectionView = CollectionView(provider: provider)
        collectionView.frame = CGRect(x: 0, y: navigationBarHeight, width: pj_width, height: pj_height)
        addSubview(collectionView)
    }
}

private extension Selector {
    static let cellTap = #selector(PJPlayCollectionView.cellTap(sender:))
}

extension PJPlayCollectionView {
    @objc
    fileprivate func cellTap(sender: UIButton) {
       
    }
}
