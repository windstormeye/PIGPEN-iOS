//
//  PJMessageViewController.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/5.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit
import YPImagePicker

class PJMessageViewController: UIViewController, PJBaseViewControllerDelegate {

    private var pullRefrasher = UIRefreshControl()
    private var tableView = PJMessageTableView()
    private var pet = PJPet.Pet()
    /// 是否为第一次加载
    private var isFirstLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    private func initView() {
        initBaseView()
        titleString = "娱乐圈"
        rightBarButtonItem(imageName: "camera", rightSel: .camera)
        
        pullRefrasher.addTarget(self, action: .refresh, for: .valueChanged)
        
        tableView = PJMessageTableView(frame: CGRect(x: 0, y: navigationBarHeight, width: view.pj_width, height: view.pj_height - navigationBarHeight - PJTABBAR_HEIGHT), style: .plain)
        view.addSubview(tableView)
        tableView.refreshControl = pullRefrasher
        
        tableView.cellSelected = {
            // 文章详情
            self.navigationController?.pushViewController(PJMessageDetailsViewController(blog: self.tableView.viewModels[$0]), animated: true)
        }
        
        tableView.cellLikeSelected = {
            let blogId = self.tableView.viewModels[self.tableView.selectedIndex].blog.id
            self.like(blogId: blogId, isLike: $0)
        }
        
        tableView.cellCollectSelected = {
            let blogId = self.tableView.viewModels[self.tableView.selectedIndex].blog.id
            self.collect(blogId: blogId, isCollect: $0)
        }
        
        reloadData(page: 1)
        isFirstLoad = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: .gotoLogin,
                                               name: .gotoLogin(),
                                               object: nil)
    }
}

extension PJMessageViewController {
    /// 获取数据
    private func reloadData(page: Int) {
        
        PIGBlog.get(page: page, complateHandler: {
            
            self.tableView.viewModels = $0
            self.tableView.reloadData()
            self.pullRefrasher.endRefreshing()
        }) {
            PJHUD.shared.showError(view: self.view, text: $0.errorMsg)
            self.pullRefrasher.endRefreshing()
        }
    }
    
    /// 点赞/取消点赞 文章
    private func like(blogId: Int, isLike: Bool) {
        
        PIGBlog.like(blogId: blogId, isLike: isLike, complateHandler: {
            
            var cellModel = self.tableView.viewModels[self.tableView.selectedIndex]
            cellModel.blog.isLike = isLike ? 1 : 0
            
            if isLike {
                cellModel.blog.likeCount += 1
            } else {
                cellModel.blog.likeCount -= 1
            }
            
            self.tableView.reloadCell(blogContent: cellModel)
            self.tableView.viewModels[self.tableView.selectedIndex] = cellModel
        }) {
            PJHUD.shared.showError(view: self.view, text: $0.errorMsg)
        }
    }
    
    /// 收藏/取消收藏 文章
    private func collect(blogId: Int, isCollect: Bool) {
        
        PIGBlog.collect(blogId: blogId, isCollect: isCollect, complateHandler: {
            
            var cellModel = self.tableView.viewModels[self.tableView.selectedIndex]
            cellModel.blog.isCollect = isCollect ? 1 : 0
    
            self.tableView.reloadCell(blogContent: cellModel)
            self.tableView.viewModels[self.tableView.selectedIndex] = cellModel
        }) {
            PJHUD.shared.showError(view: self.view, text: $0.errorMsg)
        }
    }
    
    
}

extension PJMessageViewController {
    @objc fileprivate func gotoLoginPage() {
        let navVC = UINavigationController(rootViewController: PJUserLoginViewController())
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }
    
    /// 下拉刷新
    @objc
    fileprivate func refresh() {
        pullRefrasher.beginRefreshing()
        reloadData(page: 1)
    }
    
    @objc
    fileprivate func camera() {
        PJInputSelectView.showAlertSheet {
            switch $0 {
            case 0:
                let picker = YPImagePicker(configuration: pj_YPImagePicker())
                picker.didFinishPicking { [unowned picker] items, _ in
                    if let photo = items.singlePhoto {
                        
                        PJHUD.shared.showLoading(view: self.view)
                        PJImageUploader.upload(assets: [photo.asset!], complateHandler: { [weak self] imgUrls,keys in
                            guard let `self` = self else { return }
                            
                            self.pet.avatar_url = keys[0]
    
                            let vc = PJMessageInputViewController(avatarImage: photo.image, pet: self.pet)
                            self.navigationController?.pushViewController(vc, animated: true)
                                                
                            PJHUD.shared.dismiss()
                        }) { (error) in
                            PJHUD.shared.showError(view: self.view, text: error.errorMsg)
                        }
                    }
                    picker.dismiss(animated: true, completion: nil)
                }
                self.present(picker, animated: true, completion: nil)
            case 1: break
            default: break
            }
        }
    }
}

private extension Selector {
    static let camera = #selector(PJMessageViewController.camera)
    static let refresh = #selector(PJMessageViewController.refresh)
    static let gotoLogin = #selector(PJMessageViewController.gotoLoginPage)
}
