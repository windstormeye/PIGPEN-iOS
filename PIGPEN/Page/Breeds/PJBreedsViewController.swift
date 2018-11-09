//
//  PJMessageViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/25.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJBreedsViewController: PJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "狗狗品种"
        
        RealPet.breedList(petType: "dog")
    }
}
