//
//  PJChatViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/25.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJChatViewController: RCConversationListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        self.setDisplayConversationTypes([NSNumber(integerLiteral: Int(RCConversationType.ConversationType_PRIVATE.rawValue))])
        
//        4186284364
        let chat = RCConversationViewController(conversationType: .ConversationType_PRIVATE, targetId: "4180157412")
        chat!.title = "YiYi"
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chat!, animated: true)
    }
}

