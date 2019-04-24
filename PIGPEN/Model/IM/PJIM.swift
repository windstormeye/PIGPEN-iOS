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
        guard cList != nil else { return complateHandler(msgListCells)}
        
        if cList?.count != 0 {
            var cIndex = 0
            for c in cList! {
                print(c.targetId)
                let currentMessage = RCMessage(type: .ConversationType_PRIVATE, targetId: c.targetId, direction: c.lastestMessageDirection, messageId: c.lastestMessageId, content: c.lastestMessage)
                currentMessage?.sentTime = c.sentTime
                currentMessage?.receivedTime = c.receivedTime
                currentMessage?.senderUserId = c.senderUserId
                currentMessage?.sentStatus = c.sentStatus
                if currentMessage != nil {
                    let message = getMessage(with: currentMessage!)
                    if message == nil { break }
                    PJUser.shared.details(details_uid: c.targetId, getSelf: false, completeHandler: {
                        
                        let msgCell = MessageListCell(avatar: $0.avatar!, nickName: $0.nick_name!, uid: $0.uid!, message: message!)
                            msgListCells.append(msgCell)
                        
                            if cIndex == cList!.count - 1 {
                                
                                var finalCells = [MessageListCell]()
                                for cell in cList! {
                                    for msgCell in msgListCells {
                                        if msgCell.uid == cell.targetId {
                                            finalCells.append(msgCell)
                                            break
                                        }
                                    }
                                }
                                complateHandler(finalCells)
                            }
                            cIndex += 1
                    }) {
                        print($0.errorMsg!)
                    }
                }
            }
        } else {
            complateHandler(msgListCells)
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
