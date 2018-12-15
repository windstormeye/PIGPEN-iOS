//
//  PJAlbumCollectionFocusView.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/12/15.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJAlbumCollectionFocusView: UIView {

    @IBOutlet weak private var avatarImageView: UIImageView!
    
    // MARK: - Public Methods
    // MARK:- 创建视图
    class func newInstance() -> PJAlbumCollectionFocusView? {
        let nibView = Bundle.main.loadNibNamed("PJAlbumCollectionFocusView",
                                               owner: self,
                                               options: nil);
        if let view = nibView?.first as? PJAlbumCollectionFocusView {
            return view
        }
        return nil
    }
    
    func setModel(_ model: PJAlbumDetailCollectionViewCell.cellModel) {
        avatarImageView.image = model.avatarImage
    }
}
