//
//  PJUserSearchViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/14.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJUserSearchViewController: UIViewController, PJBaseViewControllerDelegate {

    let searchBar = PJSearchBar.newInstance()!
    var tableView = PJSearchTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        initBaseView()
        titleString = "搜索"
        backButtonTapped(backSel: .back, imageName: nil)
        view.backgroundColor = .white
        
        searchBar.frame = CGRect(x: 20, y: navigationBarHeight + 10, width: view.pj_width - 40, height: 44)
        searchBar.layer.cornerRadius = searchBar.pj_height / 2
        view.addSubview(searchBar)
        
        tableView = PJSearchTableView(frame: CGRect(x: 0, y: searchBar.bottom, width: view.pj_width, height: view.pj_height - searchBar.pj_height - navigationBarHeight), style: .plain)
        view.addSubview(tableView)
        
        searchBar.returnKeyDown = { [weak self] text in
            self?.search(uid: text)
        }
        
        tableView.cellChatButtonClick = { [weak self]  in
            guard let viewModel = self?.tableView.viewModels[$0] else { return }
            
            let chat = PJIMChatViewController()
            chat.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(chat, animated: true)
            chat.messageCell = PJIM.MessageListCell(avatar: viewModel.avatar!,
                                                    nickName: viewModel.nick_name!,
                                                    uid: viewModel.uid!,
                                                    message: nil)
        }
        
        tableView.cellSelected = { [weak self] in
            guard let viewModel = self?.tableView.viewModels[$0] else { return }
            let vc = PJDetailViewController()
            vc.viewModel = viewModel
            vc.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc
    fileprivate func back() {
        popBack()
    }
    
    private func search(uid: String) {
        PJHUD.shared.showLoading(view: view)
        PJUser.shared.searchFriend(uid: uid,
                                   completeHandler: {
                                    self.tableView.viewModels = $0
                                    PJHUD.shared.dismiss()
        }) {
            print($0.errorMsg)
            PJHUD.shared.dismiss()
        }
    }
}

private extension Selector {
    static let back = #selector(PJUserSearchViewController.back)
}
