//
//  PJUserViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/25.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJUserDetailsViewController: UIViewController, PJBaseViewControllerDelegate {

    var tableView: PJUserDetailsTableView?
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
        
        rightBarButtonItem(imageName: "user_details_menu", rightSel: .menu)
        
        navigationItem.title = PJUser.shared.userModel.nick_name
        
        tableView = PJUserDetailsTableView(frame: CGRect(x: 0, y: 0, width: view.pj_width, height: view.pj_height), style: .plain)
        tableView?.viewDelegate = self
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
    static let loginSuccess = #selector(PJUserDetailsViewController.loginSuccess)
    static let menu = #selector(PJUserDetailsViewController.menu)
}

extension PJUserDetailsViewController {
    // MARK: - Notification
    @objc fileprivate func loginSuccess() {
        title = PJUser.shared.userModel.nick_name
    }
    
    @objc
    fileprivate func menu() {
        if tableView!.left != 0 {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                self.tableView!.left = 0
                self.navigationController?.navigationBar.left = 0
                self.menuTableView?.left = self.tableView!.right
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                self.tableView!.left -= self.view.pj_width * 0.4
                self.navigationController?.navigationBar.left -= self.view.pj_width * 0.4
                self.menuTableView?.left = self.tableView!.right
            }, completion: nil)
        }
    }
    
    func viewWillData() {
        if PJUser.shared.userModel.uid != nil {
            PJUser.shared.pets(complateHandler: { [weak self] realPetModels, virtualPetModels in
                guard let `self` = self else { return }
                self.tableView?.realPetModels = realPetModels
                self.tableView?.virtualPetModels = virtualPetModels
                self.tableView?.reloadData()
            }) { (error) in
                PJTapic.error()
                print(error)
            }
            
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

// MARK: - PJUserDetailsMenuViewDelegate
extension PJUserDetailsViewController: PJUserDetailsMenuViewDelegate {
    
}

// MARK: - PJUserDetailsTableViewDelegate
extension PJUserDetailsViewController: PJUserDetailsTableViewDelegate {
    func PJUserDetailsTableViewToPetDetails() {
        let vc = PJRealPetDetailsViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func PJUserDetailsTableViewToNewPet() {
        let vc = PJCreateRealPetViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.catOrDog = .dog
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
    
    func PJUserDetailsTableViewUserSelfLevel() {
        let vc = PJGradeViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func PJUserDetailsTableViewUserSelfFollow() {
        
    }
    
    func PJUserDetailsTableViewUserSelfStar() {
        
    }
}
