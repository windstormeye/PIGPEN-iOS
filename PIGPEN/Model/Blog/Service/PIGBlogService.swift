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
    
    static let like = "like/"
    static let collectCreate = "collect/create"
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
                                                return
                                            }
                                            let err = PJNetwork.Error(errorCode: $0["msgCode"]!.intValue,
                                                                      errorMsg: $0["msg"]!.stringValue)
                                            failedHandler(err)
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
                                            let blogDicts = $0["msg"]!.arrayValue
                                            
                                            for p in blogDicts {
                                                let blogContent = dataConvertToModel(PIGBlog.BlogContent(), from: try! p.rawData())
                                                blogContents.append(blogContent!)
                                            }
                                            complateHandler(blogContents)
                                            return
                                        }
                                        let err = PJNetwork.Error(errorCode: $0["msgCode"]!.intValue,
                                                                  errorMsg: $0["msg"]!.stringValue)
                                        failedHandler(err)
        }) {
            failedHandler($0)
        }
    }
    
    
    /// 点赞/取消点赞 文章
    class func like(blogId: Int,
                    isLike: Bool,
                    complateHandler: @escaping (() -> Void),
                    failedHandler: @escaping ((PJNetwork.Error) -> Void)) {
        let params = [
            "blog_id": blogId,
            "is_like": isLike ? 1 : 0
        ]
        
        PJNetwork.shared.requstWithPost(path: .like,
                                        parameters: params,
                                        complement: {
                                            if $0["msgCode"]?.intValue == 0 {
                                                complateHandler()
                                                return
                                            }
                                            let err = PJNetwork.Error(errorCode: $0["msgCode"]!.intValue,
                                                                      errorMsg: $0["msg"]!.stringValue)
                                            failedHandler(err)
        }) {
            failedHandler($0)
        }
    }
    
    /// 收藏/取消收藏 文章
    /// 点赞/取消点赞 文章
    class func collect(blogId: Int,
                       isCollect: Bool,
                       complateHandler: @escaping (() -> Void),
                       failedHandler: @escaping ((PJNetwork.Error) -> Void)) {
        let params = [
            "blog_id": blogId,
            "is_collect": isCollect ? 1 : 0
        ]
        
        PJNetwork.shared.requstWithPost(path: .collectCreate,
                                        parameters: params,
                                        complement: {
                                            if $0["msgCode"]?.intValue == 0 {
                                                complateHandler()
                                                return
                                            }
                                            let err = PJNetwork.Error(errorCode: $0["msgCode"]!.intValue,
                                                                      errorMsg: $0["msg"]!.stringValue)
                                            failedHandler(err)
        }) {
            failedHandler($0)
        }
    }
}
