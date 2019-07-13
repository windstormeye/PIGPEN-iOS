//
//  PJMessageDetailsViewController.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/8.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJMessageDetailsViewController: UIViewController, PJBaseViewControllerDelegate {

    var blog = PIGBlog.BlogContent()
    private var cell = PJMessageTableViewCell()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(blog: PIGBlog.BlogContent) {
        self.init(nibName: nil, bundle: nil)
        self.blog = blog
        
        initView()
    }
    
    private func initView() {
        hidesBottomBarWhenPushed = true
        view.backgroundColor = .white
        
        initBaseView()
        titleString = ""
        backButtonTapped(backSel: .back, imageName: nil)
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: navigationBarHeight, width: view.pj_width, height: view.pj_height))
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        cell = PJMessageTableViewCell.newInstance()
        scrollView.addSubview(cell)
        cell.frame = CGRect(x: 0, y: 0, width: view.pj_width, height: 480)
        cell.viewModel = blog
        cell.isHiddenBottomLineView(true)
        
        cell.likeSelected = {
            self.like($0)
        }
        
        cell.collectSelected = {
            self.collect($0)
        }
        
        let contentLabel = UILabel(frame: CGRect(x: 10, y: cell.bottom + 10, width: view.pj_width - 10, height: 0))
        scrollView.addSubview(contentLabel)
        contentLabel.numberOfLines = 0
        contentLabel.text = blog.blog.content
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.sizeToFit()
        
        var scrollHeight: CGFloat = 0
        if contentLabel.bottom > view.pj_height - navigationBarHeight {
            scrollHeight = contentLabel.bottom - (view.pj_height - navigationBarHeight)
        }
        
        scrollView.contentSize = CGSize(width: 0, height: view.pj_height + scrollHeight + 10)
    }
    
}

extension PJMessageDetailsViewController {
    /// 点赞/取消点赞 文章
    private func like(_ isLike: Bool) {
        
        PIGBlog.like(blogId: blog.blog.id, isLike: isLike, complateHandler: {
    
            self.blog.blog.isLike = isLike ? 1 : 0
            
            if isLike {
                self.blog.blog.likeCount += 1
            } else {
                self.blog.blog.likeCount -= 1
            }
            
            self.cell.viewModel = self.blog
        }) {
            PJHUD.shared.showError(view: self.view, text: $0.errorMsg)
        }
    }
    
    /// 收藏/取消收藏 文章
    private func collect(_ isCollect: Bool) {
        
        PIGBlog.collect(blogId: blog.blog.id, isCollect: isCollect, complateHandler: {
            
            self.blog.blog.isCollect = isCollect ? 1 : 0
            self.cell.viewModel = self.blog
        }) {
            PJHUD.shared.showError(view: self.view, text: $0.errorMsg)
        }
    }
}

extension PJMessageDetailsViewController {
    @objc
    fileprivate func back() {
        popBack()
    }
}

private extension Selector {
    static let back = #selector(PJMessageDetailsViewController.back)
}
