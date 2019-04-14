//
//  PJMessageViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/11/10.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

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
        PJIM.share().getConversionList { cells in
            self.tableView?.viewModels = cells
        }
    }
    
    @objc
    func sendMsg() {
        PJIM.share().sendText(textString: "Hello, world!",
                              userID: "4186284364",
                              complateHandler: { msgId in
                                print("发送成功")
        }) { (errorCode) in
            print(errorCode)
        }
    }
    
    @objc
    fileprivate func addressBook() {
        sendMsg()
    }
    
    @objc
    fileprivate func search() {
        
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
