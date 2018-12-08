//
//  PJAlbumTableViewCell.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/12/2.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJAlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var albumPhotosLabel: UILabel!
    
    // MARK: - Public Methods
    func setModel(_ model: PJAlbumTableViewCellModel) {
        coverImageView.image = model.coverImage
        albumTitleLabel.text = model.albumTitleString
        albumPhotosLabel.text = model.albumPhotosCountString
    }
}

extension PJAlbumTableViewCell {
    struct PJAlbumTableViewCellModel {
        let coverImage: UIImage
        let albumTitleString: String
        let albumPhotosCountString: String
    }
}
