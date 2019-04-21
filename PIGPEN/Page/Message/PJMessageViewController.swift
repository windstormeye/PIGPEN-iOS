//
//  PJMessageViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/11/10.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit
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
        
        RCIMClient.shared()?.setReceiveMessageDelegate(self, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        PJIM.share().getConversionList {
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


extension PJMessageViewController: RCIMClientReceiveMessageDelegate {
    func onReceived(_ message: RCMessage!, left nLeft: Int32, object: Any!) {
        
    }
}


private extension Selector {
    static let addressBook = #selector(PJMessageViewController.addressBook)
    static let search = #selector(PJMessageViewController.search)
}
