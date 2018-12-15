//
//  PJAlbumDetailsViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/12/15.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJAlbumDetailsViewController: PJBaseViewController {
    // MARK: - Public Properties
    var models: [PJAlbumDataManager.Photo]?
    
    // MARK: - Private Properties
    private var albumCollectionView: PJAlbumDetailCollectionView?
    private var albumFocusView: PJAlbumCollectionFocusView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        guard let models = models else { return }
        title = models[0].photoTitle
        backButtonTapped(backSel: .back)
        isHiddenBarBottomLineView = false
        view.backgroundColor = .white
        
        albumFocusView = PJAlbumCollectionFocusView.newInstance()
        albumFocusView?.frame = CGRect(x: 0, y: headerView!.bottom, width: PJSCREEN_WIDTH, height: PJSCREEN_WIDTH)
        view.addSubview(albumFocusView!)
        let focusModel = PJAlbumDetailCollectionViewCell.cellModel(avatarImage: models[0].photoImage ?? UIImage())
        albumFocusView?.setModel(focusModel)
        
        albumCollectionView = PJAlbumDetailCollectionView(frame: CGRect(x: 0, y: albumFocusView!.bottom,
                                                                    width: PJSCREEN_WIDTH,
                                                                    height: PJSCREEN_HEIGHT - PJSCREEN_WIDTH))
        view.addSubview(albumCollectionView!)
        albumCollectionView?.collectionModel = models
        albumCollectionView?.reloadData()
    }

    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }
}

fileprivate extension Selector {
    static let back = #selector(PJAlbumDetailsViewController.back)
}
