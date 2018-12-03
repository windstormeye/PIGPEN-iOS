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
    var assetResults = [PHAssetCollection]()
    
    func allAlbums() {
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                 subtype: .any,
                                                                 options: nil) as! PHFetchResult<PHCollection>
        let userAlbums = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        let albums = [smartAlbums, userAlbums]
        
        for album in albums {
            for s_i in 0..<album.count {
                let collection = album[s_i] as! PHAssetCollection
                let types: [PHAssetCollectionSubtype] = [.albumRegular, // 用户自己创建的相册d
                                                         .smartAlbumPanoramas, // 全景
                                                         .smartAlbumScreenshots, // 屏幕截图
                                                         .smartAlbumUserLibrary, // 相机胶卷
                                                         .smartAlbumRecentlyAdded] // 最近添加
                if types.contains(collection.assetCollectionSubtype) {
                    assetResults.append(collection)
                }
            }
        }
    }
    
    func albumCover(album: PHAssetCollection) -> UIImage? {
        let result = albumPHAssets(album: album)
        
        let coverSize = CGSize(width: PJSCREEN_WIDTH, height: PJSCREEN_WIDTH)
        var cover: UIImage?
        let asset = result[0]
        PHImageManager.default().requestImage(for: asset,
                                              targetSize: coverSize,
                                              contentMode: .aspectFill,
                                              options: nil) { (photo, info) in
                                                cover = photo
        }
        return cover
    }
    
    func albumPHAssets(album: PHAssetCollection) -> PHFetchResult<PHAsset> {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        let fetchResult = PHAsset.fetchAssets(in: album, options: options)
        return fetchResult
    }
}


