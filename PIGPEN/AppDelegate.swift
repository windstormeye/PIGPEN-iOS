//
//  AppDelegate.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/24.
//  Copyright © 2018年 PJHubs. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var window: UIWindow?
    private var rootTabBar: UITabBarController?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.registerForRemoteNotifications()
        
        rootTabBar = UITabBarController()
        rootTabBar?.tabBar.isTranslucent = false
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIStoryboard(name: "PJCreatePetSelfDetailsViewController", bundle: nil).instantiateViewController(withIdentifier: "PJCreatePetSelfDetailsViewController")
//        window?.rootViewController = rootTabBar
        window?.makeKeyAndVisible()
        
//        initTabBarControler()
//        IQKeyboardManager.shared.enable = true
//        requestPushNotification(application)
//        Bugly.start(withAppId: "i1400197107")
//
//        RCIMClient.shared()?.initWithAppKey("kj7swf8ok3sq2")
//        PJUser.shared.connectRC(completeHandler: {
//            print("融云 IM 登录成功: " + $0)
//        }) { (error) in
//            print(error.errorMsg )
//        }
        
        return true
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        guard PJUser.shared.userModel.uid != -1 else { return }
//        RCIMClient.shared()?.setDeviceToken(deviceToken.toHexString())
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PIGPEN")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

extension AppDelegate {
    // MARK: - Init
    private func initTabBarControler() {
        let homePage = PJHomeViewController()
        let homeNav = UINavigationController(rootViewController: homePage)
        homeNav.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0,
                                                      bottom: -5, right: 0)
        homeNav.tabBarItem.image = UIImage(named: "tab_home")?.withRenderingMode(.alwaysOriginal)
        homeNav.tabBarItem.selectedImage = UIImage(named: "tab_home_selected")?.withRenderingMode(.alwaysOriginal)
        
        let chatPage = PJMessageViewController()
        let chatNav = UINavigationController(rootViewController: chatPage)
        chatNav.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0,
                                                      bottom: -5, right: 0)
        chatNav.tabBarItem.image = UIImage(named: "tab_chat")?.withRenderingMode(.alwaysOriginal)
        chatNav.tabBarItem.selectedImage = UIImage(named: "tab_chat_selected")?.withRenderingMode(.alwaysOriginal)
        
        let playPage = PJPlayViewController()
        let playNav = UINavigationController(rootViewController: playPage)
        playNav.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0,
                                                      bottom: -5, right: 0)
        playNav.tabBarItem.image = UIImage(named: "tab_play")?.withRenderingMode(.alwaysOriginal)
        playNav.tabBarItem.selectedImage = UIImage(named: "tab_play_selected")?.withRenderingMode(.alwaysOriginal)
        
        let messagePage = PJPlayViewController()
        let messageNav = UINavigationController(rootViewController: messagePage)
        messageNav.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0,
                                                         bottom: -5, right: 0)
        messageNav.tabBarItem.image = UIImage(named: "tab_friend")?.withRenderingMode(.alwaysOriginal)
        messageNav.tabBarItem.selectedImage = UIImage(named: "tab_friend_selected")?.withRenderingMode(.alwaysOriginal)
        
        let userPage = PJUserCenterViewController()
        let userNav = UINavigationController(rootViewController: userPage)
        userNav.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0,
                                                      bottom: -5, right: 0)
        userNav.tabBarItem.image = UIImage(named: "tab_user")?.withRenderingMode(.alwaysOriginal)
        userNav.tabBarItem.selectedImage = UIImage(named: "tab_user_selected")?.withRenderingMode(.alwaysOriginal)
        
        
        rootTabBar?.viewControllers = [homeNav, chatNav, playNav, messageNav, userNav]
    }
}

extension AppDelegate {
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate {
    func requestPushNotification(_ application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
            if $1 == nil {
                if $0 {
                    print("YES")
                } else {
                    print("NO")
                }
            } else {
                print($1!.localizedDescription)
            }
        }
    }
}
