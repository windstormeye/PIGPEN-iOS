//
//  PJIM.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/9.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import Foundation

@objc class PJIM: NSObject {
    var getMsg: ((Message) -> Void)?
    
    private static let instance = PJIM()
    class func share() -> PJIM {
        return instance
    }
    
    override init() {
        super.init()
        RCIMClient.shared()?.setReceiveMessageDelegate(self, object: nil)
    }
    
    /// 发送文本消息
    func sendText(textString: String,
                  userID: String,
                  complateHandler: @escaping (() -> Void),
                  failerHandler: @escaping ((RCErrorCode) -> Void)) {
        let text = RCTextMessage(content: textString)
        RCIMClient.shared()?.sendMessage(.ConversationType_PRIVATE,
                                         targetId: userID,
                                         content: text,
                                         pushContent: nil,
                                         pushData: nil,
                                         success: { (mesId) in
                                            complateHandler()
        }, error: { (errorCode, mesId) in
            failerHandler(errorCode)
        })
    }
}

extension PJIM: RCIMClientReceiveMessageDelegate {
    func onReceived(_ message: RCMessage!, left nLeft: Int32, object: Any!) {
        print(message.objectName)
        switch message.objectName {
        case "RC:TxtMsg":
            let text = message.content as! RCTextMessage
            let m = Message(type: .text,
                            textContent: text.content,
                            audioContent: nil,
                            sendUserId: message.senderUserId,
                            msgId: message.messageId,
                            msgDirection: message.messageDirection,
                            msgStatus: message.sentStatus,
                            msgReceivedTime: message.receivedTime,
                            msgSentTime: message.sentTime)
            self.getMsg?(m)
        case "RCImageMessage": break
        default: break
        }
    }
}


extension PJIM {
    enum MessageType {
        case text
        case audio
    }
    
    struct Message {
        var type: MessageType
        var textContent: String?
        var audioContent: Data?
        var sendUserId: String
        var msgId: Int
        var msgDirection: RCMessageDirection
        var msgStatus: RCSentStatus
        var msgReceivedTime: Int64
        var msgSentTime: Int64
    }
}
