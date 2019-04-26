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
    var selectedPhoto: PJAlbumDataManager.Photo?
    // Closure
    var selectedComplateHandler: ((PJAlbumDataManager.Photo) -> Void)?
    
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
        selectedPhoto = models[0]
        
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
            self.selectedPhoto = models[selectedIndex]
//            let p_size = UIScreen.main.bounds.width
//            PJAlbumDataManager.manager().convertPHAssetToUIImage(asset: self.currentAlbumAssets![selectedIndex],
//                                                                 size: CGSize(width: p_size, height: p_size),
//                                                                 mode: .highQualityFormat,
//                                                                 complateHandler: { (photoImage) in
//                                                                    let avatar = photoImage ?? UIImage()
//                                                                    self.albumFocusView?.setModel(PJAlbumDetailCollectionViewCell.cellModel(avatarImage: avatar))
//            })
        }
        
        albumCollectionView?.scrollDidScroll = { [weak self] offset_y in
            guard let `self` = self else { return }
            guard let albumFocusView = self.albumFocusView else { return }
            guard let headerView = self.headerView else { return }
            
            albumFocusView.top = -offset_y + headerView.pj_height
            if albumFocusView.bottom < headerView.pj_height {
                albumFocusView.bottom = headerView.pj_height
            }
            if albumFocusView.top > headerView.bottom {
                albumFocusView.top = headerView.bottom
            }
            
            self.albumCollectionView?.top = albumFocusView.bottom
            self.albumCollectionView?.pj_height = PJSCREEN_HEIGHT - albumFocusView.bottom
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
        guard let selectedPhoto = selectedPhoto else { return }
        selectedComplateHandler?(selectedPhoto)
        navigationController?.popViewController(animated: true)
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
                self.selectedPhoto = photos[0]
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
