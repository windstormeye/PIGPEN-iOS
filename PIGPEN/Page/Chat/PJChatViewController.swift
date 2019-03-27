//
//  PJChatViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/25.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJChatViewController: PJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    private func initView() {
        let cvc = TConversationController()
        cvc.delegate = self
        addChild(cvc)
        view.addSubview(cvc.view)
    }
}

extension PJChatViewController: TConversationControllerDelegagte {
    func conversationController(_ conversationController: TConversationController!,
                                didSelectConversation conversation: TConversationCellData!) {
        
    }
    
    func conversationController(_ conversationController: TConversationController!,
                                didClickRightBarButton rightBarButton: UIButton!) {
        let add = TAddMemberController()
        add.delegate = self
        addChild(add)
        view.addSubview(add.view)
    }
}


extension PJChatViewController: TAddMemberControllerDelegate {
    func didCancel(in controller: TAddMemberController!) {
        
    }
    
    func addMemberController(_ controller: TAddMemberController!, didAddMemberResult result: TAddMemberResult!) {
        print(result.code)
        print(result.desc)
        print(result.addMembers)
        print(result.groupId)
    }
}
