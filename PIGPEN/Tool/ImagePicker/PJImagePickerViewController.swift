//
//  PJImagePickerViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/24.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit
import YPImagePicker

class PJImagePickerViewController: UIViewController, PJBaseViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        backButtonTapped(backSel: .back, imageName: "nav_back")
        view.backgroundColor = .white
        
        var config = YPImagePickerConfiguration()
        config.startOnScreen = .library
        config.screens = [.library]
        config.hidesStatusBar = false
        config.hidesBottomBar = true
        
        config.library.numberOfItemsInRow = 3
        config.library.spacingBetweenItems = 3.0
        config.library.skipSelectionsGallery = false
        
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
            }
        }
        addChild(picker)
        view.addSubview(picker.view)
    }
    
    @objc
    fileprivate func back() {
        dismiss(animated: true, completion: nil)
    }
}

private extension Selector {
    static let back = #selector(PJImagePickerViewController.back)
}


