//
//  PJAlbumViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/12/1.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJAlbumViewController: PJBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataManager = PJAlbumDataManager()
        dataManager.allAlbums()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: PJSCREEN_WIDTH, height: PJSCREEN_WIDTH))
        view.addSubview(imageView)
        imageView.image = dataManager.albumCover(album: dataManager.assetResults[0])
        
    }

}

