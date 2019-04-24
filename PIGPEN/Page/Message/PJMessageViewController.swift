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

class PJMessageViewController: UIViewController, PJBaseViewControllerDelegate {
    
    private var tableView: PJIMMessageHomeTableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleString = "信息"
        initBaseView()
        leftBarButtonItemTapped(leftTapped: .addressBook,
                                imageName: "message_book")
        rightBarButtonItem(imageName: "message_search",
                           rightSel: .search)
        view.backgroundColor = .white
        requestPush()
        
        
        tableView = PJIMMessageHomeTableView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height), style: .plain)
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        titleString = "消息接收中..."
        // TODO: 后续列表太卡优化这里
        PJIM.share().getConversionList {
            self.titleString = "消息"
            self.tableView?.viewModels = $0
        }
    }
    
    @objc
    fileprivate func addressBook() {
        
    }
    
    @objc
    fileprivate func search() {
        let vc = PJUserSearchViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
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
    static let addressBook = #selector(PJMessageViewController.addressBook)
    static let search = #selector(PJMessageViewController.search)
}
