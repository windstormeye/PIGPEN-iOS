//
//  NotificationName.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/4.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    static func loginSuccess() -> NSNotification.Name {
        return NSNotification.Name("PJNotificationLoginSuccess")
    }
    
    static func gotoLogin() -> NSNotification.Name {
        return NSNotification.Name("PJNotificationGotoLogin")
    }
    
    static func enterBackground() -> NSNotification.Name {
        return NSNotification.Name("PJNotificationEnterBackground")
    }
}
