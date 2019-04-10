//
//  PJMessageViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/11/10.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJMessageViewController: PJBaseViewController {
    
    private var tableView: PJIMMessageHomeTableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleString = "信息"
        leftBarButtonItemTapped(leftTapped: .addressBook,
                                imageName: "message_book")
        rightBarButtonItem(imageName: "message_search",
                           rightSel: .search)
        view.backgroundColor = .white
        
        
        tableView = PJIMMessageHomeTableView(frame: CGRect(x: 0, y: headerView!.bottom, width: view.width, height: view.height - headerView!.height), style: .plain)
        view.addSubview(tableView!)
        tableView?.cellSelected = { cellIndex in
            let message = self.tableView?.viewModels[cellIndex]
            let chat = PJIMChatViewController()
            chat.messageCell = message
            chat.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(chat, animated: true)
        }
        
        RCIMClient.shared()?.setReceiveMessageDelegate(self, object: nil)
        
        PJIM.share().getConversionList { cells in
            self.tableView?.viewModels = cells
        }
        
        
    }
    
    @objc
    func sendMsg() {
        PJIM.share().sendText(textString: "Hello, world!",
                              userID: "4186284364",
                              complateHandler: {
                                print("发送成功")
        }) { (errorCode) in
            print(errorCode)
        }
    }
    
    @objc
    fileprivate func addressBook() {
        
    }
    
    @objc
    fileprivate func search() {
        
    }
}


extension PJMessageViewController: RCIMClientReceiveMessageDelegate {
    func onReceived(_ message: RCMessage!, left nLeft: Int32, object: Any!) {
        print(message.objectName)
        switch message.objectName {
        case "RC:TxtMsg":
            let text = message.content as! RCTextMessage
            let m = PJIM.Message(type: .text,
                            textContent: text.content,
                            audioContent: nil,
                            sendUserId: message.senderUserId,
                            msgId: message.messageId,
                            msgDirection: message.messageDirection,
                            msgStatus: message.sentStatus,
                            msgReceivedTime: message.receivedTime,
                            msgSentTime: message.sentTime)
            print(m.textContent!)
        case "RCImageMessage": break
        default: break
        }
    }
}


private extension Selector {
    static let addressBook = #selector(PJMessageViewController.addressBook)
    static let search = #selector(PJMessageViewController.search)
}
