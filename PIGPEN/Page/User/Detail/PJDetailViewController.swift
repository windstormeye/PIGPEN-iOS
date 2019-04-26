//
//  PJDetailViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/15.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJDetailViewController: UIViewController {
    var viewModel: PJUser.UserModel? {
        didSet {
            
        }
    }
    
    private var tableView = PJDetailTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        view.backgroundColor = .white
        tableView = PJDetailTableView(frame: CGRect(x: 0, y: navigationBarHeight, width: view.pj_width, height: view.pj_height - navigationBarHeight), style: .plain)
        view.addSubview(tableView)
    }
}
