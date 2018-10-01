//
//  PJBaseViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/1.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJBaseViewController: UIViewController {

    var headerView: UIView?
    
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(),
                                                               for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        let titleTextAtt = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = titleTextAtt
        
        headerView = UIView(frame: CGRect(x: 0, y: 0,
                                          width: view.width,
                                          height: navigationBarHeight))
        view.addSubview(headerView!)
        
        
        if navigationController?.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) ?? false {
            navigationController?.interactivePopGestureRecognizer?.delegate = nil
        }
        
    }
    
    
    // MARK: Action
    func backButtonTapped(backSel: Selector) {
        let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        leftButton.setImage(UIImage(named: "backButton"), for: .normal)
        leftButton.addTarget(self, action: backSel, for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem.init(customView: leftButton)
        navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
    }
    

    // MARK: setter and getter
    var statusBarHeight: CGFloat {
        get {
            return UIApplication.shared.statusBarFrame.size.height
        }
    }
    var navigationBarHeight: CGFloat {
        get {
            return statusBarHeight + navigationController!.navigationBar.height
        }
    }

}
