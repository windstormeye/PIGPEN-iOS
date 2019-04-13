//
//  UIViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/13.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

protocol PJBaseViewControllerProtocol: UIViewController {
    var headerView: UIView? {get}
    var titleString: String { get set }
    
    func initBaseView()
    func popBack()
    func backButtonTapped(backSel: Selector, imageName: String?)
    func leftBarButtonItemTapped(leftTapped: Selector, imageName: String)
}

extension PJBaseViewControllerProtocol {
    var headerView: UIView? {
        get {
            return view.subviews.filter { return $0.tag == 0509 }.first
        }
    }
    
    var titleString: String {
        get { return navigationItem.title ?? "" }
        set { navigationItem.title = newValue }
    }
    
    func initBaseView() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(),
                                                               for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        let titleTextAtt = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = titleTextAtt
        
        let h_v = UIView(frame: CGRect(x: 0, y: 0,
                                       width: view.width,
                                       height: navigationBarHeight))
        h_v.tag = 0510
        h_v.backgroundColor = .white
        view.addSubview(h_v)
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
