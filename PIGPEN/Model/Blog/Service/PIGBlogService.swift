//
//  PIGBlogService.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/6.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import Foundation

private extension String {
    static let create = "blog/create"
    static let get = "blog/"
}

extension PIGBlog {
    
    /// 创建一篇文章
    class func create(blog: Blog,
                      petIds: String,
                      complateHandler: @escaping (() -> Void),
                      failedHandler: @escaping ((PJNetwork.Error) -> Void)) {
        let params = [
            "content": blog.content,
            "imgs": blog.imgs,
            "petIds": petIds
        ]
        
        PJNetwork.shared.requstWithPost(path: .create,
                                        parameters: params,
                                        complement: {
                                            if $0["msgCode"]?.intValue == 0 {
                                                complateHandler()
                                            }
        }) {
            failedHandler($0)
        }
    }
    
    /// 获取所有文章
    class func get(page: Int,
                   complateHandler: @escaping (([PIGBlog.BlogContent]) -> Void),
                   failedHandler: @escaping ((PJNetwork.Error) -> Void)) {
        let params = [
            "page": String(page),
        ]
        
        PJNetwork.shared.requstWithGet(path: .get,
                                       parameters: params,
                                       complement: {
                                        if $0["msgCode"]?.intValue == 0 {
                                            var blogContents = [PIGBlog.BlogContent]()
                                            let blogDicts = $0["msg"]!["blogs"].arrayValue
                                            
                                            for p in blogDicts {
                                                let blogContent = dataConvertToModel(PIGBlog.BlogContent(), from: try! p.rawData())
                                                blogContents.append(blogContent!)
                                            }
                                            complateHandler(blogContents)
                                        }
        }) {
            failedHandler($0)
        }
    }
}
