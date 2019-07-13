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
        /// id
        var id: Int
        /// 文本内容
        var content: String
        /// 图片 URL
        var imgs: String
        /// 点赞数
        var likeCount: Int
        /// 阅读数
        var readCount: Int
        /// 是否点赞过
        var isLike: Int
        /// 是否收藏过
        var isCollect: Int
        
        var createdTime: Int
        var updatedTime: Int
        
        init() {
            id = 0
            content = ""
            imgs = ""
            likeCount = 0
            isLike = 0
            isCollect = 0
            readCount = 0
            createdTime = 0
            updatedTime = 0
        }
    }
}
