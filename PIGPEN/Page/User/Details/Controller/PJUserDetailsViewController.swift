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
    static let menu = #selector(PJUserDetailsViewController.menu)
}

class PJUserDetailsViewController: PJBaseViewController,
PJUserDetailsMenuViewDelegate, PJUserDetailsTableViewDelegate {

    var tableView: PJUserDetailsTableView?
    var menuBackViewButton: UIButton?
    
    // MARK: init Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    private func initView() {
        headerView?.backgroundColor = .white
        isHiddenBarBottomLineView = false
        rightBarButtonItem(imageName: "user_details_menu", rightSel: .menu)
        
        navigationItem.title = PJUser.shared.nickName
        
        tableView = PJUserDetailsTableView(frame: CGRect(x: 0, y: headerView!.height,
                                                         width: view.width,
                                                         height: view.height - headerView!.height),
                                           style: .plain)
        tableView?.viewDelegate = self
        view.addSubview(tableView!)
        
        menuBackViewButton = UIButton(frame: view.frame)
        menuBackViewButton?.addTarget(self, action: .menu, for: .touchUpInside)
        menuBackViewButton?.isHidden = true
        menuBackViewButton?.backgroundColor = .clear
        view.addSubview(menuBackViewButton!)
        
        NotificationCenter.default.addObserver(self,
                                               selector: .loginSuccess,
                                               name: .loginSuccess(),
                                               object: nil)
    }
    
    // MARK: - Notification
    @objc fileprivate func loginSuccess() {
        title = PJUser.shared.nickName
    }
    
    @objc fileprivate func menu() {
        menuView.isHidden = !menuView.isHidden
        menuBackViewButton?.isHidden = !menuBackViewButton!.isHidden
    }
    
    // MARK: Delegate
    func PJUserDetailsTableViewToPetDetails() {
        let vc = PJRealPetDetailsViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func PJUserDetailsTableViewToNewPet() {
        let vc = PJCreateRealPetViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func PJUserDetailsTableViewVirtualPetToNewPet() {
        let vc = PJCreateVirtualPetViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func PJUserDetailsTableViewVirtualPetToDetails() {
        let vc = PJVirtualPetViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func PJUserDetailsTableViewMoneyLook() {
        
    }
    
    func PJUserDetailsTableViewMoneySteal() {
        
    }
    
    // MARK: lazy load
    lazy var menuView: PJUserDetailsMenuView = {
        let menu = PJUserDetailsMenuView.newInstance()
        menu?.viewDelegate = self
        menu?.isHidden = true
        let menuWidth = 120.0
        let menuHeight = 180.0
        menu?.frame = CGRect(x: PJSCREEN_WIDTH - menuWidth - 15,
                             y: Double(headerView!.bottom),
                             width: menuWidth, height: menuHeight)
        view.addSubview(menu!)
        return menu!
    }()
}
