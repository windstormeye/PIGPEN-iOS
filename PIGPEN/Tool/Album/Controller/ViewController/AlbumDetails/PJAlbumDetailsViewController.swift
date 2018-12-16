//
//  PJAlbumDetailsViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/12/15.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit
import Photos

class PJAlbumDetailsViewController: PJBaseViewController {
    // MARK: - Public Properties
    var models: [PJAlbumDataManager.Photo]?
    var currentAlbumCollection: PHAssetCollection?
    var currentAlbumAssets: PHFetchResult<PHAsset>?
    
    // MARK: - Private Properties
    private var albumCollectionView: PJAlbumDetailCollectionView?
    private var albumFocusView: PJAlbumCollectionFocusView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        guard let models = models else { return }
        
        view.backgroundColor = .white
        title = "\(models[0].photoTitle ?? "") ▾"
        let navTapped = UITapGestureRecognizer(target: self, action: .navigationBarTapped)
        navigationController?.navigationBar.addGestureRecognizer(navTapped)
        
        isHiddenBarBottomLineView = false
        backButtonTapped(backSel: .back)
        rightBarButtonItem(imageName: "ok", rightSel: .ok)
        
        
        albumFocusView = PJAlbumCollectionFocusView.newInstance()
        albumFocusView?.frame = CGRect(x: 0, y: headerView!.bottom, width: PJSCREEN_WIDTH, height: PJSCREEN_WIDTH)
        view.addSubview(albumFocusView!)
        let focusModel = PJAlbumDetailCollectionViewCell.cellModel(avatarImage: models[0].photoImage ?? UIImage())
        albumFocusView?.setModel(focusModel)
        
        albumCollectionView = PJAlbumDetailCollectionView(frame: CGRect(x: 0, y: albumFocusView!.bottom,
                                                                    width: PJSCREEN_WIDTH,
                                                                    height: PJSCREEN_HEIGHT - albumFocusView!.bottom))
        view.addSubview(albumCollectionView!)
        albumCollectionView?.collectionModel = models
        albumCollectionView?.reloadData()
        albumCollectionView?.selectedCell = { [weak self] selectedIndex in
            guard let `self` = self else { return }
            
            let avatar = models[selectedIndex].photoImage ?? UIImage()
            self.albumFocusView?.setModel(PJAlbumDetailCollectionViewCell.cellModel(avatarImage: avatar))
            
//            let p_size = UIScreen.main.bounds.width
//            PJAlbumDataManager.manager().convertPHAssetToUIImage(asset: self.currentAlbumAssets![selectedIndex],
//                                                                 size: CGSize(width: p_size, height: p_size),
//                                                                 mode: .highQualityFormat,
//                                                                 complateHandler: { (photoImage) in
//                                                                    let avatar = photoImage ?? UIImage()
//                                                                    self.albumFocusView?.setModel(PJAlbumDetailCollectionViewCell.cellModel(avatarImage: avatar))
//            })
        }
    }
}

fileprivate extension Selector {
    static let back = #selector(PJAlbumDetailsViewController.back)
    static let ok = #selector(PJAlbumDetailsViewController.ok)
    static let navigationBarTapped = #selector(PJAlbumDetailsViewController.navigationBarTapped)
}

extension PJAlbumDetailsViewController {
    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func ok() {
        
    }
    
    @objc fileprivate func navigationBarTapped() {
        let vc = PJAlbumViewController()
        vc.complateHander = { album in
            // TODO: 选 QQ、Vary 等相册有问题
            self.currentAlbumCollection = album
            PJAlbumDataManager.manager().getAlbumPhotos(albumCollection: album, complateHandler: { [weak self] photos, assets  in
                guard let `self` = self else { return }
                self.models = photos
                self.currentAlbumAssets = assets
                
                self.albumFocusView?.setModel(PJAlbumDetailCollectionViewCell.cellModel(avatarImage: photos[0].photoImage ?? UIImage()))
                
//                let p_size = UIScreen.main.bounds.width
//                PJAlbumDataManager.manager().convertPHAssetToUIImage(asset: self.currentAlbumAssets![0],
//                                                                     size: CGSize(width: p_size, height: p_size),
//                                                                     mode: .highQualityFormat,
//                                                                     complateHandler: { (photoImage) in
//                                                                        let avatar = photoImage ?? UIImage()
//                                                                        self.albumFocusView?.setModel(PJAlbumDetailCollectionViewCell.cellModel(avatarImage: avatar))
//                })
                
                self.albumCollectionView?.collectionModel = photos
                self.albumCollectionView?.reloadData()
            })
        }
        
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
}

