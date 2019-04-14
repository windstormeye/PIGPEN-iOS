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
                  complateHandler: @escaping ((Int) -> Void),
                  failerHandler: @escaping ((RCErrorCode) -> Void)) {
        let text = RCTextMessage(content: textString)
        RCIMClient.shared()?.sendMessage(.ConversationType_PRIVATE,
                                         targetId: userID,
                                         content: text,
                                         pushContent: nil,
                                         pushData: nil,
                                         success: { (mesId) in
                                            complateHandler(mesId)
        }, error: { (errorCode, mesId) in
            failerHandler(errorCode)
        })
    }
    
    /// 获取本地会话列表
    func getConversionList(_ complateHandler: @escaping (([MessageListCell]) -> Void)) {
        let cTypes = [NSNumber(value: RCConversationType.ConversationType_PRIVATE.rawValue)]
        let cList = RCIMClient.shared()?.getConversationList(cTypes) as? [RCConversation]
        
        var msgListCells = [MessageListCell]()
        if cList != nil {
            for (cIndex, c) in cList!.enumerated() {
                print(c.targetId)
                let currentMessage = RCMessage(type: .ConversationType_PRIVATE,
                                               targetId: c.targetId,
                                               direction: c.lastestMessageDirection,
                                               messageId: c.lastestMessageId,
                                               content: c.lastestMessage)
                currentMessage?.senderUserId = c.senderUserId
                if currentMessage != nil {
                    let message = getMessage(with: currentMessage!)
                    if message == nil { break }
                    PJUser.shared.details(details_uid: c.targetId,
                                          getSelf: false,
                                          completeHandler: { (userModel) in
                                            let msgCell = MessageListCell(avatar: userModel.avatar!,
                                                                          nickName: userModel.nick_name!,
                                                                          uid: userModel.uid!,
                                                                          message: message!)
                                            msgListCells.append(msgCell)
                                            
                                            if cIndex == cList!.count - 1 {
                                                complateHandler(msgListCells)
                                            }
                    }) { (error) in
                        print(error.errorMsg!)
                    }
                }
            }
        }
    }
    
    private func getMessage(with rcMessage: RCMessage) -> Message? {
        switch rcMessage.objectName {
            case "RC:TxtMsg":
                let text = rcMessage.content as! RCTextMessage
                let m = Message(type: .text,
                                textContent: text.content,
                                audioContent: nil,
                                sendUserId: rcMessage.senderUserId,
                                msgId: rcMessage.messageId,
                                msgDirection: rcMessage.messageDirection,
                                msgStatus: rcMessage.sentStatus,
                                msgReceivedTime: rcMessage.receivedTime,
                                msgSentTime: rcMessage.sentTime)
                return m
            case "RCImageMessage": break
            default: break
        }
        return nil
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
            getMsg?(m)
            print(m.textContent!)
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
    
    struct MessageListCell {
        var avatar: Int
        var nickName: String
        var uid: String
        var message: Message?
    }
}
