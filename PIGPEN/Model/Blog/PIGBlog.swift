//
//  PIGBlog.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/5.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import Foundation

class PIGBlog {
    static let shared = PIGBlog()
    
    init() {
        
    }
}

extension PIGBlog {
    struct BlogContent: Codable {
        var blog: Blog
        var pet: PJPet.Pet
        
        init() {
            blog = Blog()
            pet = PJPet.Pet()
        }
    }
    
    struct Blog: Codable {
        /// 文本内容
        var content: String
        /// 图片 URL
        var imgs: String
        /// 点赞数
        var likeCount: Int
        /// 阅读数
        var readCount: Int
        // TODO: 记得做
        /// 当前是否收藏过
//        var isCollectd: Int
        
        var createdTime: Int
        var updatedTime: Int
        
        init() {
            content = ""
            imgs = ""
            likeCount = 0
//            isCollectd = 0
            readCount = 0
            createdTime = 0
            updatedTime = 0
        }
    }
}
