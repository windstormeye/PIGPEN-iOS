//
//  PJAlbumViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/12/1.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit
import Photos

class PJAlbumViewController: PJBaseViewController {
    
    // MARK: - Private Property
    private var albumTableView: PJAlbumTableView?
    
    
    // MARK: - Private Methonds
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let indexPath = albumTableView?.indexPathForSelectedRow
        if indexPath != nil {
            let cell = albumTableView?.cellForRow(at: indexPath!)
            cell?.setSelected(false, animated: true)
        }
    }
    
    private func initView() {
        title = "选择照片"
        backButtonTapped(backSel: .back)
        isHiddenBarBottomLineView = false

        PHPhotoLibrary.shared().register(self)
        
        albumTableView = PJAlbumTableView(frame: CGRect(x: 0, y: headerView!.bottom,
                                                        width: PJSCREEN_WIDTH,
                                                        height: PJSCREEN_HEIGHT - headerView!.height),
                                          style: .plain)
        view.addSubview(albumTableView!)

        albumTableView?.didSelectedCell = { [weak self] selectedIndex in
            guard let `self` = self else { return }
            let album = PJAlbumDataManager.manager().albums[selectedIndex]
            let vc = PJAlbumDetailsViewController()
            PJAlbumDataManager.manager().getAlbumPhotos(albumCollection: album, complateHandler: { (photos) in
                vc.models = photos
                self.navigationController?.pushViewController(vc, animated: true)
            })
        }
        
        PJAlbumDataManager.manager().getAlbumCovers { [weak self] coverPhotos, albumPhotosCounts  in
            guard let `self` = self else { return }
        
            let tableModels = PJAlbumTableView.PJAlbumTableViewModel.init(albumCoverPhoto: coverPhotos,
                                                                          albumPhotosCount: albumPhotosCounts)
            self.albumTableView?.tableModels = tableModels
            self.albumTableView?.reloadData()
        }
    }

    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }
}

fileprivate extension Selector {
    static let back = #selector(PJAlbumViewController.back)
}


extension PJAlbumViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
    }
    
}
