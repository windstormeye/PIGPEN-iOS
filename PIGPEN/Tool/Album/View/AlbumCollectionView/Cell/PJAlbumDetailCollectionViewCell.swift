//
//  PJAlbumDetailCollectionViewCell.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/12/2.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJAlbumDetailCollectionViewCell: UICollectionViewCell {

    // MARK: - Private Propertys
    @IBOutlet private weak var avatarImageView: UIImageView!
    
    // MARK: - Public Methods
    func setModel(model: cellModel) {
        avatarImageView.image = model.avatarImage
    }

}

extension PJAlbumDetailCollectionViewCell {
    struct cellModel {
        let avatarImage: UIImage
    }
}
