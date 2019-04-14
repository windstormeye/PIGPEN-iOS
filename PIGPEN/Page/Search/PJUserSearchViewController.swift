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
        
        searchBar.frame = CGRect(x: 20, y: navigationBarHeight + 10, width: view.width - 40, height: 44)
        searchBar.layer.cornerRadius = searchBar.height / 2
        view.addSubview(searchBar)
        
        tableView = PJSearchTableView(frame: CGRect(x: 0, y: searchBar.bottom, width: view.width, height: view.height - searchBar.height - navigationBarHeight), style: .plain)
        view.addSubview(tableView)
    }
    
    @objc
    fileprivate func back() {
        popBack()
    }
}

private extension Selector {
    static let back = #selector(PJUserSearchViewController.back)
}
