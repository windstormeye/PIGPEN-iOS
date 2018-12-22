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
    
    var albums: [PHAssetCollection] {
        return allAlbumCollection()
    }
    
    // MARK: - Private Property
    private static let instance: PJAlbumDataManager = {
        return PJAlbumDataManager()
    }()

    // MARK: - Public Methonds
    /// 获取所有相册封面及照片数
    func getAlbumCovers(complateHandler: @escaping (_ coverPhotos: [Photo], _ albumPhotosCounts: [Int]) -> Void) {
        let albumCollections = albums
        var photos = [Photo]()
        var photosCount = [Int]()
        // 获取单张照片资源是异步过程，需要等待所有相册的封面图片一起 append 完后再统一通过逃逸闭包进行返回
        var c_index = 0
        for collection in albumCollections {
            let assets = albumPHAssets(collection)
            // 有些系统自带相册类型如果用户没有进行照片归类则会导致取到的相片数为0
            guard assets.count != 0 else {
                c_index += 1
                continue
            }
            
            photosCount.append(assets.count)
            
            var photo = Photo()
            photo.photoTitle = collection.localizedTitle
            convertPHAssetToUIImage(asset: assets[0],
                                    size: CGSize(width: 150, height: 150),
                                    mode: .fastFormat) { (photoImage) in
                                        photo.photoImage = photoImage
                                        photos.append(photo)
                                        c_index += 1
                
                                        if c_index == albumCollections.count - 1 {
                                            complateHandler(photos, photosCount)
                                        }
            }
        }
    }
    
    /// 获取某一相册的所有照片
    func getAlbumPhotos(albumCollection: PHAssetCollection,
                        complateHandler: @escaping (([Photo], PHFetchResult<PHAsset>) -> Void)) {
        let assets = albumPHAssets(albumCollection)
        var photos = [Photo]()
    
        for a_index in 0..<assets.count {
            var photo = Photo()
            convertPHAssetToUIImage(asset: assets[a_index],
                                    size: CGSize(width: 150, height: 150),
                                    mode: .highQualityFormat) { (photoImage) in
                                        photo.photoImage = photoImage
                                        photo.photoTitle = albumCollection.localizedTitle ?? ""
                                        photos.append(photo)
                
                                        if a_index == assets.count - 1 {
                                            complateHandler(photos, assets)
                                        }
            }
        }
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
    
    /// PHAsset 转 UIImage
    func convertPHAssetToUIImage(asset: PHAsset,
                                         size: CGSize,
                                         mode: PHImageRequestOptionsDeliveryMode,
                                         complateHandler: @escaping (_ photo: UIImage?) -> Void) {
        let coverSize = size
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = mode
        options.isNetworkAccessAllowed = true
        PHImageManager.default().requestImage(for: asset,
                                              targetSize: coverSize,
                                              contentMode: .default,
                                              options: options) { result, info in
                                                guard result != nil else { return complateHandler(nil) }
                                                complateHandler(result)
        }
    }
    
    /// 当前相册的所有 PJAsset
    private func albumPHAssets(_ collection: PHAssetCollection) -> PHFetchResult<PHAsset> {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(in: collection, options: options)
        return fetchResult
    }
}


extension PJAlbumDataManager {
    /// 照片
    struct Photo {
        /// 所属相册名称
        var photoTitle: String? = ""
        /// 照片
        var photoImage: UIImage? = nil
    }
    
    /// 相册
    struct Album {
        let photos: [Photo]
    }
}
