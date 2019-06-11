//
//  PJUserViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/25.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJUserCenterViewController: UIViewController, PJBaseViewControllerDelegate {

    var tableView = PJUserCenterTableView()
    var menuTableView: PJSideMenuTableView?
    var menuBackViewButton: UIButton?
    var isFirstLoad = false
    
    // MARK: init Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard isFirstLoad else {
            isFirstLoad = true
            return
        }
        viewWillData()
    }

    private func initView() {
        initBaseView()
        titleString = PJUser.shared.userModel.nick_name
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        
        rightBarButtonItem(imageName: "user_sideMenu", rightSel: .menu)
        leftBarButtonItem(imageName: "user_visitors", leftSel: .vistors)
        
        
        tableView = PJUserCenterTableView(frame: CGRect(x: 0, y: 0, width: view.pj_width , height: view.pj_height - PJTABBAR_HEIGHT), style: .plain)
        tableView.frame = view.bounds
//        tableView?.viewDelegate = self
        view.addSubview(tableView)
        tableView.createPet = {
            let sb = UIStoryboard(name: "PJPetCreateViewController", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "PJPetCreateViewController")
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        menuBackViewButton = UIButton(frame: view.frame)
        menuBackViewButton?.addTarget(self, action: .menu, for: .touchUpInside)
        menuBackViewButton?.isHidden = true
        menuBackViewButton?.backgroundColor = .clear
        view.addSubview(menuBackViewButton!)
        
        menuTableView = PJSideMenuTableView(frame: CGRect(x: view.pj_width, y: 0, width: view.pj_width * 0.4, height: view.pj_height), style: .plain)
        view.addSubview(menuTableView!)
        menuTableView?.update(["关于我们", "分享名片", "退出登录"],
                              ["user_aboutMe", "user_share", "user_out"])
        menuTableView?.didSelectedCell = {
            print($0)
        }
        
        
        viewWillData()
        
        NotificationCenter.default.addObserver(self,
                                               selector: .loginSuccess,
                                               name: .loginSuccess(),
                                               object: nil)
    }
}

// MARK: - Actions
fileprivate extension Selector {
    static let loginSuccess = #selector(PJUserCenterViewController.loginSuccess)
    static let menu = #selector(PJUserCenterViewController.menu)
    static let vistors = #selector(PJUserCenterViewController.vistors)
}

extension PJUserCenterViewController {
    // MARK: - Notification
    @objc fileprivate func loginSuccess() {
        title = PJUser.shared.userModel.nick_name
    }
    
    @objc
    fileprivate func vistors() {
        
    }
    
    @objc
    fileprivate func menu() {
        if tableView.left != 0 {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                self.tableView.left = 0
                self.navigationController?.navigationBar.left = 0
                self.tabBarController?.tabBar.left = 0
                self.menuTableView?.left = self.tableView.right
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                self.tableView.left -= sideMenuWidth
                self.navigationController?.navigationBar.left -= sideMenuWidth
                self.menuTableView?.left = self.tableView.right
                self.tabBarController?.tabBar.left -= sideMenuWidth
            }, completion: nil)
        }
    }
    
    func viewWillData() {
        if PJUser.shared.userModel.token != nil {
            PJUser.shared.pets(complateHandler: {
                self.tableView.pets = $0
            }) { (error) in
                PJTapic.error()
                print(error)
            }
            
            PJUser.shared.details(details_uid: String(PJUser.shared.userModel.uid),
                                  getSelf: true,
                                  completeHandler: { (userModel) in
                                    self.tableView.userDetailsModel = userModel
                                    self.tableView.reloadData()
            }) { (error) in
                PJTapic.error()
                print(error)
            }
        }
    }
}
