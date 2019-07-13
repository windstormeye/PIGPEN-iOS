//
//  PJBaseViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/1.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let gotoLogin = #selector(PJBaseViewController.gotoLoginPage)
}

class PJBaseViewController: UIViewController {
    var titleString = "" { didSet { navigationItem.title = titleString }}
    var headerView: UIView?
    var lineView: UIView?
    // default is false
    var isHiddenBarBottomLineView: Bool? {
        didSet {
            didSetIsHiddenBarBottomLineView()
        }
    }
    
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(),
                                                               for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        let titleTextAtt = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = titleTextAtt
        
        headerView = UIView(frame: CGRect(x: 0, y: 0,
                                          width: view.pj_width,
                                          height: navigationBarHeight))
        headerView?.backgroundColor = .white
        view.addSubview(headerView!)
        
        
        lineView = UIView(frame: CGRect(x: 0, y: headerView!.bottom - 0.5,
                                            width: view.pj_width, height: 0.5))
        lineView?.backgroundColor = .boderColor
        view.addSubview(lineView!)
        
        // 解决自定义 leftBarButtonItem 后侧滑失效，除非自定义 backBarButtonItem
        if navigationController?.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) ?? false {
            navigationController?.interactivePopGestureRecognizer?.delegate = nil
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: .gotoLogin,
                                               name: .gotoLogin(),
                                               object: nil)
    }
    
    // MARK: Action
    func leftBarButtonItemTapped(leftTapped: Selector, imageName: String) {
        let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40,
                                                height: 40))
        leftButton.setImage(UIImage(named: imageName), for: .normal)
        leftButton.addTarget(self, action: leftTapped, for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem.init(customView: leftButton)
        navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
    }
    
    func backButtonTapped(backSel: Selector?) {
        let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40,
                                                height: 40))
        leftButton.setImage(UIImage(named: "nav_back"), for: .normal)
        if backSel != nil {
            leftButton.addTarget(self, action: backSel!, for: .touchUpInside)
        } else {
            
        }
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
    
    private func didSetIsHiddenBarBottomLineView() {
        lineView?.isHidden = isHiddenBarBottomLineView!
    }
    
    @objc fileprivate func gotoLoginPage() {
        let navVC = UINavigationController(rootViewController: PJUserLoginViewController())
        present(navVC, animated: true, completion: nil)
    }
    
    // MARK: setter and getter
    var statusBarHeight: CGFloat {
        get {
            return UIApplication.shared.statusBarFrame.size.height
        }
    }
    var navigationBarHeight: CGFloat {
        get {
            return statusBarHeight + navigationController!.navigationBar.pj_height
        }
    }

}
