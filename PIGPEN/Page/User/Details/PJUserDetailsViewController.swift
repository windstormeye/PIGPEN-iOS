//
//  PJUserViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/25.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let loginSuccess = #selector(PJUserDetailsViewController.loginSuccess)
}

class PJUserDetailsViewController: PJBaseViewController {

    var tableView: PJUserDetailsTableView?
    
    // MARK: init Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    private func initView() {
        headerView?.backgroundColor = .white
        isHiddenBarBottomLineView = false
        
        navigationItem.title = PJUser.shared.nickName
        
        tableView = PJUserDetailsTableView(frame: CGRect(x: 0, y: headerView!.height,
                                                         width: view.width,
                                                         height: view.height - headerView!.height),
                                           style: .plain)
        view.addSubview(tableView!)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: .loginSuccess,
                                               name: .loginSuccess(),
                                               object: nil)
    }
    
    // MARK: - Notification
    @objc fileprivate func loginSuccess() {
        title = PJUser.shared.nickName
    }
}
