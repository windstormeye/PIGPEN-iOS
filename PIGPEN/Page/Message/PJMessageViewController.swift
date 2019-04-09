//
//  PJMessageViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/11/10.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJMessageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(sendMsg))
        view.addGestureRecognizer(tap)
        
        RCIMClient.shared()?.setReceiveMessageDelegate(self, object: nil)
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
