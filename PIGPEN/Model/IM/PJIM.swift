//
//  PJIM.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/9.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import Foundation
import CoreLocation
import MessageKit

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
    
    /// 获取会话列表
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
                let m = Message(type: .text(text.content),
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
        let m = getMessage(with: message)
        print(m?.textContent!)
    }
}


extension PJIM {
    
    struct Message {
        var type: MessageKind
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
        var message: Message
    }
}


struct PJIMMessage: MessageType {
    
    var messageId: String
    var sender: Sender
    var sentDate: Date
    var kind: MessageKind
    
    private init(kind: MessageKind,
                 sender: Sender,
                 messageId: String,
                 date: Date) {
        self.kind = kind
        self.sender = sender
        self.messageId = messageId
        self.sentDate = date
    }
    
    init(custom: Any?,
         sender: Sender,
         messageId: String,
         date: Date) {
        self.init(kind: .custom(custom),
                  sender: sender,
                  messageId: messageId,
                  date: date)
    }
    
    init(text: String,
         sender: Sender,
         messageId: String,
         date: Date) {
        self.init(kind: .text(text),
                  sender: sender,
                  messageId: messageId,
                  date: date)
    }
    
    init(attributedText: NSAttributedString,
         sender: Sender,
         messageId: String,
         date: Date) {
        self.init(kind: .attributedText(attributedText),
                  sender: sender,
                  messageId: messageId,
                  date: date)
    }
    
    init(image: UIImage,
         sender: Sender,
         messageId: String,
         date: Date) {
        let mediaItem = ImageMediaItem(image: image)
        self.init(kind: .photo(mediaItem),
                  sender: sender,
                  messageId: messageId,
                  date: date)
    }
    
    init(thumbnail: UIImage,
         sender: Sender,
         messageId: String,
         date: Date) {
        let mediaItem = ImageMediaItem(image: thumbnail)
        self.init(kind: .video(mediaItem),
                  sender: sender,
                  messageId: messageId,
                  date: date)
    }
    
    init(location: CLLocation,
         sender: Sender,
         messageId: String,
         date: Date) {
        let locationItem = CoordinateItem(location: location)
        self.init(kind: .location(locationItem),
                  sender: sender,
                  messageId: messageId,
                  date: date)
    }
    
    init(emoji: String,
         sender: Sender,
         messageId: String,
         date: Date) {
        self.init(kind: .emoji(emoji),
                  sender: sender,
                  messageId: messageId,
                  date: date)
    }
    
}

private struct CoordinateItem: LocationItem {
    
    var location: CLLocation
    var size: CGSize
    
    init(location: CLLocation) {
        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }
    
}

private struct ImageMediaItem: MediaItem {
    
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
    
}
