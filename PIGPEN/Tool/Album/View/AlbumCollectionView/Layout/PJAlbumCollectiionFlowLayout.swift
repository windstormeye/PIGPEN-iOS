//
//  PJAlbumCollectiionFlowLayout.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/12/15.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

fileprivate let itemMargin = 2.0
fileprivate let itemSizeWidth = (Double(PJSCREEN_WIDTH) - 2 * itemMargin) / 3

class PJAlbumCollectiionFlowLayout: UICollectionViewFlowLayout {
    
    
    override init() {
        super.init()
        initLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initLayout() {
        itemSize = CGSize(width: itemSizeWidth, height: itemSizeWidth)
        scrollDirection = .vertical
        minimumLineSpacing = CGFloat(itemMargin)
        minimumInteritemSpacing = CGFloat(itemMargin)
    }
}
