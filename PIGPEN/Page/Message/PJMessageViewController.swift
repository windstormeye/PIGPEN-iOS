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
        
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(sendMsg))
//        view.addGestureRecognizer(tap)
//
//        let b = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
//        view.addSubview(b)
//        b.setTitle("接收消息", for: .normal)
//        b.addTarget(self, action: #selector(getMsg), for: .touchUpInside)
//        b.backgroundColor = .black
        
        tableView = PJIMMessageHomeTableView(frame: CGRect(x: 0, y: headerView!.bottom, width: view.width, height: view.height - headerView!.height), style: .plain)
        view.addSubview(tableView!)
        
        
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
    func getMsg() {
        present(PJIMMessageViewController(), animated: true, completion: nil)
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
