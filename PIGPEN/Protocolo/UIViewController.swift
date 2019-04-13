//
//  UIViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/13.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

protocol PJBaseViewControllerDelegate: UIViewController {
    var titleString: String { get set }
    
    func initBaseView()
    func popBack()
    func backButtonTapped(backSel: Selector, imageName: String?)
    func leftBarButtonItemTapped(leftTapped: Selector, imageName: String)
    func rightBarButtonItem(imageName: String, rightSel: Selector)
}

extension PJBaseViewControllerDelegate {
    var titleString: String {
        get { return navigationItem.title ?? "" }
        set { navigationItem.title = newValue }
    }
    
    func initBaseView() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .white
        
        let titleTextAtt = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = titleTextAtt
    }
    
    func popBack() {
        dissmisCurrentVC(navc: navigationController, currenVC: self)
    }
    
    func leftBarButtonItemTapped(leftTapped: Selector, imageName: String) {
        let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40,
                                                height: 40))
        leftButton.setImage(UIImage(named: imageName), for: .normal)
        leftButton.addTarget(self, action: leftTapped, for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem.init(customView: leftButton)
        navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
    }
    
    func rightBarButtonItem(imageName: String, rightSel: Selector) {
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40,
                                                 height: 40))
        rightButton.setImage(UIImage(named: imageName), for: .normal)
        rightButton.addTarget(self, action: rightSel, for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem.init(customView: rightButton)
        navigationItem.setRightBarButton(leftBarButtonItem, animated: true)
    }
    
    func backButtonTapped(backSel: Selector, imageName: String?) {
        let leftButton = UIButton(frame: CGRect(x: 0, y: 0,
                                                width: 40,
                                                height: 40))
        var finalImageName = "nav_back"
        if imageName != nil {
            finalImageName = imageName!
        }
        leftButton.setImage(UIImage(named: finalImageName), for: .normal)
        leftButton.addTarget(self, action: backSel, for: .touchUpInside)
        
        let leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
    }
}
