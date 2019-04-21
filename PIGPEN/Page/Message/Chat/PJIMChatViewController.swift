//
//  PJIMMessageViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/9.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit
import MessengerKit

class PJIMChatViewController: MSGMessengerViewController, PJBaseViewControllerDelegate {
    var messageCell: PJIM.MessageListCell? { didSet { didSetMessageCell() }}
    var id = 100
    
    private var friendUser: ChatUser?
    private var meUser: ChatUser?

    var messages = [[MSGMessage]]()
    lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        return df
    }()
    
    override var style: MSGMessengerStyle {
        return CustomStyle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        initBaseView()
        backButtonTapped(backSel: .back, imageName: nil)
        
        PJIM.share().getMsg = { msg in
            switch msg.type {
            case .text:
                let msgMsg = MSGMessage(id: msg.msgId,
                                        body: MSGMessageBody.text(msg.textContent!),
                                        user: self.friendUser!,
                                        sentAt: Date(timeIntervalSince1970: TimeInterval(msg.msgSentTime)))
                DispatchQueue.main.async {
                    self.insert(msgMsg)
                }
                break;
            case .audio: break
            }
        }
    }
    
    @objc
    fileprivate func back() {
        popBack()
    }
    
    private func didSetMessageCell() {
        // 如果有未读消息数，进入聊天后就全部已读
        let badge = RCIMClient.shared()!.getUnreadCount(.ConversationType_PRIVATE, targetId: messageCell!.uid)
        if (badge != 0) {
            RCIMClient.shared()!.clearMessagesUnreadStatus(.ConversationType_PRIVATE, targetId: messageCell!.uid)
            UIApplication.shared.applicationIconBadgeNumber -= Int(badge)
        }
        
        titleString = messageCell!.nickName
        friendUser = ChatUser(displayName: messageCell!.nickName,
                              avatar: UIImage(named: "\(messageCell!.avatar)"),
                              isSender: false)
        meUser = ChatUser(displayName: PJUser.shared.userModel.nick_name!,
                          avatar: UIImage(named: "\(PJUser.shared.userModel.avatar!)"),
                              isSender: true)
        
        func update(_ ms: [RCMessage]) {
            var m_index = 0
            var tempMsgs = [MSGMessage]()
            var tempMsgUserId = messageCell?.uid
            messages.append(tempMsgs)
            
            for m in ms {
                let text = m.content as! RCTextMessage
                if tempMsgUserId != m.senderUserId {
                    tempMsgs.removeAll()
                    messages.append(tempMsgs)
                    m_index += 1
                    tempMsgUserId = m.senderUserId
                }
                
                let c_m: MSGMessage?
                if m.senderUserId != PJUser.shared.userModel.uid! {
                    c_m = MSGMessage(id: m.messageId,
                                     body: .text(text.content),
                                     user: friendUser!,
                                     sentAt: Date(timeIntervalSince1970: TimeInterval(m.sentTime)))
                } else {
                    c_m = MSGMessage(id: m.messageId,
                                     body: .text(text.content),
                                     user: meUser!,
                                     sentAt: Date(timeIntervalSince1970: TimeInterval(m.sentTime)))
                }
                tempMsgs.insert(c_m!, at: 0)
                messages.insert(tempMsgs, at: m_index)
                messages.remove(at: m_index + 1)
            }
            
            messages.reverse()
        }
        
        let ms = RCIMClient.shared()?.getLatestMessages(.ConversationType_PRIVATE, targetId: messageCell?.uid, count: 30) as? [RCMessage]
        if ms != nil {
            DispatchQueue.main.async {
                update(ms!)
                self.collectionView.reloadData()
                self.collectionView.scrollToBottom(animated: true)
            }
        } else {
            // TODO: 这部分有问题，需要交钱才能拉取到服务器上的历史消息
            RCIMClient.shared()?.getRemoteHistoryMessages(.ConversationType_PRIVATE, targetId: PJUser.shared.userModel.uid!, recordTime: 0, count: 20, success: { (messages: [RCMessage]) in
                    update(messages)
                } as? ([Any]?) -> Void, error: { (errorCode) in
                    print(errorCode.rawValue)
            })
        }
    }
    
    override func inputViewPrimaryActionTriggered(inputView: MSGInputView) {
        PJIM.share().sendText(textString: inputView.message,
                              userID: messageCell!.uid,
                              complateHandler: { mesId in
                                let body: MSGMessageBody = .text(inputView.message)
                                let message = MSGMessage(id: mesId,
                                                         body: body,
                                                         user: self.meUser!,
                                                         sentAt: Date())
                                DispatchQueue.main.async {
                                    self.insert(message)
                                }
        }) { (errorCode) in
            print(errorCode)
        }
    }
    
    override func insert(_ message: MSGMessage) {
        collectionView.performBatchUpdates({
            if let lastSection = self.messages.last, let lastMessage = lastSection.last, lastMessage.user.displayName == message.user.displayName {
                self.messages[self.messages.count - 1].append(message)

                let sectionIndex = self.messages.count - 1
                let itemIndex = self.messages[sectionIndex].count - 1
                self.collectionView.insertItems(at: [IndexPath(item: itemIndex, section: sectionIndex)])

            } else {
                self.messages.append([message])
                let sectionIndex = self.messages.count - 1
                self.collectionView.insertSections([sectionIndex])
            }
        }, completion: { (_) in
            self.collectionView.scrollToBottom(animated: true)
            self.collectionView.layoutTypingLabelIfNeeded()
        })

    }
    
    override func insert(_ messages: [MSGMessage], callback: (() -> Void)? = nil) {

        collectionView.performBatchUpdates({
            for message in messages {
                if let lastSection = self.messages.last, let lastMessage = lastSection.last, lastMessage.user.displayName == message.user.displayName {
                    self.messages[self.messages.count - 1].append(message)

                    let sectionIndex = self.messages.count - 1
                    let itemIndex = self.messages[sectionIndex].count - 1
                    self.collectionView.insertItems(at: [IndexPath(item: itemIndex, section: sectionIndex)])

                } else {
                    self.messages.append([message])
                    let sectionIndex = self.messages.count - 1
                    self.collectionView.insertSections([sectionIndex])
                }
            }
        }, completion: { (_) in
            self.collectionView.scrollToBottom(animated: false)
            self.collectionView.layoutTypingLabelIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                callback?()
            }
        })
    }
    
    func isPreviousMessageSameSender(at section: Int) -> Bool {
        guard section - 1 >= 0 else { return false }
        return messages[section].first!.user.displayName == messages[section - 1].first!.user.displayName
    }
    
    func isNextMessageSameSender(at section: Int) -> Bool {
        guard section + 1 < messages.count else { return false }
        return messages[section].first!.user.displayName == messages[section + 1].first!.user.displayName
    }
    
}

private extension Selector {
    static let back = #selector(PJIMChatViewController.back)
}

// MARK: - MSGDataSource

extension PJIMChatViewController: MSGDataSource {
    
    func numberOfSections() -> Int {
        return messages.count
    }
    
    func numberOfMessages(in section: Int) -> Int {
        return messages[section].count
    }
    
    func message(for indexPath: IndexPath) -> MSGMessage {
        return messages[indexPath.section][indexPath.item]
    }
    
    func footerTitle(for section: Int) -> String? {
        return nil
    }
    
    func headerTitle(for section: Int) -> String? {
        return dateFormatter.string(from: messages[section].first!.sentAt)
//        if isPreviousMessageSameSender(at: section) {
//            return dateFormatter.string(from: messages[section].first!.sentAt)
//        }
//        return nil
    }
    
}

extension PJIMChatViewController: MSGDelegate {
    
}

struct ChatUser: MSGUser {
    var displayName: String
    var avatar: UIImage?
    var isSender: Bool
}
