//
//  PJAlbumDataController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/12/2.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import Foundation
import Photos

class PJAlbumDataManager {
    // MARK: - Public property
    class func manager() -> PJAlbumDataManager {
        return instance
    }
    
    /// 所有相册封面
    var albumCovers = [Photo]()
    /// 所有相册的内容
    var albums = [Album]()
    
    
    // MARK: - Private Property
    private static let instance: PJAlbumDataManager = {
        return PJAlbumDataManager()
    }()
    
    // MARK: - Public Methods
    
    // MARK: - Life Cycle
    private init() {
        albumCover(allAlbumCollection())
    }
    
    // MARK: - Private Methods
    /// 获取所有相册
    private func allAlbumCollection() -> [PHAssetCollection] {
        var collections = [PHAssetCollection]()
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                 subtype: .any,
                                                                 options: nil) as! PHFetchResult<PHCollection>
        let userAlbums = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        
        for album in [smartAlbums, userAlbums] {
            for s_i in 0..<album.count {
                let collection = album[s_i] as! PHAssetCollection
                let types: [PHAssetCollectionSubtype] = [.albumRegular, // 用户自己创建的相册
                                                         .smartAlbumPanoramas, // 全景
                                                         .smartAlbumScreenshots, // 屏幕截图
                                                         .smartAlbumUserLibrary, // 相机胶卷
                                                         .smartAlbumRecentlyAdded] // 最近添加
                if types.contains(collection.assetCollectionSubtype) {
                    collections.append(collection)
                }
            }
        }
        return collections
    }
    
    /// 获取所有相册封面
    private func albumCover(_ collections: [PHAssetCollection]) {
        let coverSize = CGSize(width: 150, height: 150)
        
        for collection in collections {
            let assets = albumPHAssets(collection)
            var photos = [Photo]()
            for index in 0..<assets.count {
                let options = PHImageRequestOptions()
                options.isSynchronous = false
                options.deliveryMode = .fastFormat
                options.isNetworkAccessAllowed = true
                PHImageManager.default().requestImage(for: assets[index],
                                                      targetSize: coverSize,
                                                      contentMode: .default,
                                                      options: options) { (result, info) -> Void in
                                                        if let photoImage = result {
                                                            let photo = Photo(photoTitle: collection.localizedTitle ?? "",
                                                                              photoImage: photoImage)
                                                            if index == 0 {
                                                                self.albumCovers.append(photo)
                                                            }
                                                            photos.append(photo)
                                                            if index == assets.count - 1 {
                                                                self.albums.append(Album(photos: photos))
                                                            }
                                                        }
                }
            }
        }
    }
    
    private func albumPHAssets(_ collection: PHAssetCollection) -> PHFetchResult<PHAsset> {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        let fetchResult = PHAsset.fetchAssets(in: collection, options: options)
        return fetchResult
    }
}


extension PJAlbumDataManager {
    /// 照片
    struct Photo {
        /// 所属相册名称
        let photoTitle: String
        /// 照片
        let photoImage: UIImage
    }
    
    /// 相册
    struct Album {
        let photos: [Photo]
    }
}
