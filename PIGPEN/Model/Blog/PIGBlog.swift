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
    struct Blog {
        /// 文本内容
        var content: String
        /// 图片 URL 地址数组
        var imgs: [String]
        /// 点赞数
        var likes: Int
        /// 当前是否收藏过
        var is_collectd: Int
        
        var created_time: Int
        var updated_time: Int
        
        init() {
            content = ""
            imgs = []
            likes = 0
            is_collectd = 0
            created_time = 0
            updated_time = 0
        }
    }
}
