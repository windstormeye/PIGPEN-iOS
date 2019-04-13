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
    
    var friendUser: ChatUser?
    var meUser: ChatUser?

    var messages = [[MSGMessage]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        initBaseView()
        backButtonTapped(backSel: .back, imageName: nil)
    }
    
    @objc
    fileprivate func back() {
        popBack()
    }
    
    private func didSetMessageCell() {
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
                if tempMsgUserId != m.targetId {
                    tempMsgs.removeAll()
                    messages.append(tempMsgs)
                    m_index += 1
                }
                tempMsgUserId = m.targetId
                
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
                tempMsgs.append(c_m!)
                tempMsgs.reverse()
                messages.insert(tempMsgs, at: m_index)
                messages.remove(at: m_index + 1)
            }
        }
        
        let ms = RCIMClient.shared()?.getLatestMessages(.ConversationType_PRIVATE, targetId: messageCell?.uid, count: 30) as? [RCMessage]
        if ms != nil {
            update(ms!)
        } else {
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
        return "Just now"
    }
    
    func headerTitle(for section: Int) -> String? {
        return messages[section].first?.user.displayName
    }
    
}


extension PJIMChatViewController: MSGDelegate {
    
}

struct ChatUser: MSGUser {
    var displayName: String
    var avatar: UIImage?
    var isSender: Bool
}
