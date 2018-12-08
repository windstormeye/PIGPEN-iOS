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
        
        let r = PJAlbumDataManager.manager().albums
    }

}

