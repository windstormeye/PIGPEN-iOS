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
    config.colors.tintColor = .black
    config.showsFilters = false
    config.targetImageSize = YPImageSize.cappedTo(size: 100)
    
    let overlayView = UIImageView(image: UIImage(named: "avatar_overlayer"))
    overlayView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth)
    config.overlayView = overlayView
    
    config.library.numberOfItemsInRow = 3
    config.library.spacingBetweenItems = 3.0

    return config
}
