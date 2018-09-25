//
//  AppDelegate.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/24.
//  Copyright © 2018年 PJHubs. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var window: UIWindow?
    private var rootTabBar: UITabBarController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        rootTabBar = UITabBarController()
        rootTabBar?.tabBar.isTranslucent = false
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootTabBar
        window?.makeKeyAndVisible()
        
        initTabBarControler()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Init
    
    private func initTabBarControler() {
        let homePage = PJHomeViewController()
        let homeNav = UINavigationController(rootViewController: homePage)
        homeNav.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        homeNav.tabBarItem.image = UIImage(named: "tabBar_home")?.withRenderingMode(.alwaysOriginal)
        
        let chatPage = PJChatViewController()
        let chatNav = UINavigationController(rootViewController: chatPage)
        chatNav.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        chatNav.tabBarItem.image = UIImage(named: "tabBar_chat")?.withRenderingMode(.alwaysOriginal)
        
        let playPage = PJPlayViewController()
        let playNav = UINavigationController(rootViewController: playPage)
        playNav.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        playNav.tabBarItem.image = UIImage(named: "tabBar_play")?.withRenderingMode(.alwaysOriginal)
        
        let messagePage = PJMessageViewController()
        let messageNav = UINavigationController(rootViewController: messagePage)
        messageNav.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        messageNav.tabBarItem.image = UIImage(named: "tabBar_message")?.withRenderingMode(.alwaysOriginal)
        
        let userPage = PJUserViewController()
        let userNav = UINavigationController(rootViewController: userPage)
        userNav.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        userNav.tabBarItem.image = UIImage(named: "tabBar_user")?.withRenderingMode(.alwaysOriginal)
        
        
        rootTabBar?.viewControllers = [homeNav, chatNav, playNav, messageNav, userNav]
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

