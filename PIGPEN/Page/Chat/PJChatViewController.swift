//
//  PJMessageViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/11/10.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit
import MessengerKit
import UserNotifications

class PJChatViewController: UIViewController, PJBaseViewControllerDelegate {
    
    private var tableView: PJIMMessageHomeTableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleString = "信息"
        initBaseView()
        leftBarButtonItem(imageName: "message_book",
                          leftSel: .addressBook)
        rightBarButtonItem(imageName: "message_search",
                           rightSel: .search)
        view.backgroundColor = .white
        requestPush()
        
        
        tableView = PJIMMessageHomeTableView(frame: CGRect(x: 0, y: 0, width: view.pj_width, height: view.pj_height), style: .plain)
        view.addSubview(tableView!)
        tableView?.cellSelected = { cellIndex in
            let chat = PJIMChatViewController()
            chat.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(chat, animated: true)
            let message = self.tableView?.viewModels[cellIndex]
            chat.messageCell = message
        }
        
        PJIM.share().getMsg = { msg in
            switch msg.type {
            case .text:
                var cell: PJIM.MessageListCell?
                var index = 0
                for (i, c) in self.tableView!.viewModels.enumerated() {
                    if c.message?.sendUserId == msg.sendUserId { cell = c; index = i }
                }
                if cell != nil {
                    cell!.message?.textContent = msg.textContent
                    cell!.message?.msgSentTime = msg.msgSentTime
                    cell!.message?.msgStatus = msg.msgStatus
                    
                    DispatchQueue.main.async {
                        self.tableView?.viewModels[index] = cell!
                    }
                }
                break;
            case .audio: break
            }
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: .gotoLogin,
                                               name: .gotoLogin(),
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        titleString = "消息接收中..."
        // TODO: 后续列表太卡优化这里
        PJIM.share().getConversionList {
            self.titleString = "消息"
            self.tableView?.viewModels = $0
        }
        
        PJUser.shared.friends(type: .user, completeHandler: {
            print($0)
        }) {
            print($0.errorMsg)
        }
    }
    
    @objc
    fileprivate func addressBook() {
        navigationController?.pushViewController(PJFriendViewController(), animated: true)
    }
    
    @objc
    fileprivate func search() {
        let vc = PJUserSearchViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc fileprivate func gotoLoginPage() {
        let navVC = UINavigationController(rootViewController: PJUserLoginViewController())
        present(navVC, animated: true, completion: nil)
    }
    
    private func requestPush() {
        UNUserNotificationCenter.current().getNotificationSettings {
            if $0.authorizationStatus != .authorized {
                let alertController = UIAlertController(title: "PIGPEN 需要推送权限", message: "开启权限后你就可以及时收到好友给你发送的消息啦～", preferredStyle: .alert)
                let alerAction = UIAlertAction(title: "去开启", style: .default, handler: { _ in
                    let settingUrl = URL(string: UIApplication.openSettingsURLString)!
                    if UIApplication.shared.canOpenURL(settingUrl) {
                        UIApplication.shared.open(settingUrl, options: [:], completionHandler: nil)
                    }
                })
                let cancleAction = UIAlertAction(title: "取消", style: .default, handler: { _ in
                    alertController.dismiss(animated: true, completion: nil)
                })
                
                alertController.addAction(cancleAction)
                alertController.addAction(alerAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}


private extension Selector {
    static let addressBook = #selector(PJChatViewController.addressBook)
    static let search = #selector(PJChatViewController.search)
    static let gotoLogin = #selector(PJChatViewController.gotoLoginPage)
}
