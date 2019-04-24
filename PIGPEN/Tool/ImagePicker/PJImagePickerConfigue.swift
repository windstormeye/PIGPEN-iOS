//
//  PJImagePickerConfigue.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/24.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import Foundation
import YPImagePicker

func pj_YPImagePicker() -> YPImagePickerConfiguration {
    var config = YPImagePickerConfiguration()
    config.startOnScreen = .library
    config.screens = [.library]
    config.hidesStatusBar = false
    config.hidesBottomBar = true
    
    config.library.numberOfItemsInRow = 3
    config.library.spacingBetweenItems = 3.0
    config.library.skipSelectionsGallery = false
    
    return config
}
