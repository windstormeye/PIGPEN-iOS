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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var window: UIWindow?
    private var rootTabBar: UITabBarController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        rootTabBar = UITabBarController()
        rootTabBar?.tabBar.isTranslucent = false
        rootTabBar?.delegate = self
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootTabBar
        window?.makeKeyAndVisible()
        
        initTabBarControler()
        
        IQKeyboardManager.shared.enable = true
        
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
        let homePage = PJGradeViewController()
        let homeNav = UINavigationController(rootViewController: homePage)
        homeNav.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0,
                                                      bottom: -5, right: 0)
        homeNav.tabBarItem.image = UIImage(named: "tabBar_home")?.withRenderingMode(.alwaysOriginal)
        
        let chatPage = PJChatViewController()
        let chatNav = UINavigationController(rootViewController: chatPage)
        chatNav.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0,
                                                      bottom: -5, right: 0)
        chatNav.tabBarItem.image = UIImage(named: "tabBar_chat")?.withRenderingMode(.alwaysOriginal)
        
        let playPage = PJPlayViewController()
        let playNav = UINavigationController(rootViewController: playPage)
        playNav.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0,
                                                      bottom: -5, right: 0)
        playNav.tabBarItem.image = UIImage(named: "tabBar_play")?.withRenderingMode(.alwaysOriginal)
        
        let messagePage = PJMessageViewController()
        let messageNav = UINavigationController(rootViewController: messagePage)
        messageNav.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0,
                                                         bottom: -5, right: 0)
        messageNav.tabBarItem.image = UIImage(named: "tabBar_message")?.withRenderingMode(.alwaysOriginal)
        
        let userPage = PJUserDetailsViewController()
        let userNav = UINavigationController(rootViewController: userPage)
        userNav.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0,
                                                      bottom: -5, right: 0)
        userNav.tabBarItem.image = UIImage(named: "tabBar_user")?.withRenderingMode(.alwaysOriginal)
        
        
        rootTabBar?.viewControllers = [homeNav, chatNav, playNav, messageNav, userNav]
        rootTabBar?.tabBar.showBottomLine(in: 0)
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

extension AppDelegate: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController,
                                 didSelect viewController: UIViewController) {
        tabBarController.tabBar.showBottomLine(in: tabBarController.selectedIndex)
    }
}
