//
//  PJFriendViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/26.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJFriendViewController: UIViewController, PJBaseViewControllerDelegate {
    var tableView: PJFriendTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initBaseView()
        backButtonTapped(backSel: .back, imageName: "nav_back")
        titleString = "好友"
        view.backgroundColor = .white
        
        tableView = PJFriendTableView(frame: CGRect(x: 0, y: navigationBarHeight, width: view.pj_width, height: view.pj_height - navigationBarHeight - PJTABBAR_HEIGHT), style: .plain)
        view.addSubview(tableView)
    }

    @objc
    fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }
}

private extension Selector {
    static let back = #selector(PJFriendViewController.back)
}
