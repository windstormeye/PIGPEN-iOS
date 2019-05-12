//
//  PJUserViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/25.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJUserCenterViewController: UIViewController, PJBaseViewControllerDelegate {

    var tableView: PJUserCenterTableView?
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
        titleString = PJUser.shared.userModel.nick_name ?? "未登录"
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        
        rightBarButtonItem(imageName: "user_sideMenu", rightSel: .menu)
        leftBarButtonItem(imageName: "user_visitors", leftSel: .vistors)
        
        navigationItem.title = PJUser.shared.userModel.nick_name
        
        tableView = PJUserCenterTableView(frame: CGRect(x: 0, y: 0, width: view.pj_width, height: view.pj_height), style: .plain)
        tableView?.pets = [PJPet.Pet(), PJPet.Pet(), PJPet.Pet(), PJPet.Pet()]
//        tableView?.viewDelegate = self
        view.addSubview(tableView!)
        
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
        let sb = UIStoryboard(name: "PJPetCreateViewController", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PJPetCreateViewController")
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
//        if tableView!.left != 0 {
//            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
//                self.tableView!.left = 0
//                self.navigationController?.navigationBar.left = 0
//                self.tabBarController?.tabBar.left = 0
//                self.menuTableView?.left = self.tableView!.right
//            }, completion: nil)
//        } else {
//            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
//                self.tableView!.left -= sideMenuWidth
//                self.navigationController?.navigationBar.left -= sideMenuWidth
//                self.menuTableView?.left = self.tableView!.right
//                self.tabBarController?.tabBar.left -= sideMenuWidth
//            }, completion: nil)
//        }
    }
    
    func viewWillData() {
        if PJUser.shared.userModel.uid != nil {
//            PJUser.shared.pets(complateHandler: { [weak self] realPetModels, virtualPetModels in
//                guard let `self` = self else { return }
//                self.tableView?.realPetModels = realPetModels
//                self.tableView?.virtualPetModels = virtualPetModels
//                self.tableView?.reloadData()
//            }) { (error) in
//                PJTapic.error()
//                print(error)
//            }
            
            PJUser.shared.details(details_uid: PJUser.shared.userModel.uid ?? "",
                                  getSelf: true,
                                  completeHandler: { (userModel) in
                                    self.tableView?.userDetailsModel = userModel
                                    self.tableView?.reloadData()
            }) { (error) in
                PJTapic.error()
                print(error)
            }
        }
    }
}
