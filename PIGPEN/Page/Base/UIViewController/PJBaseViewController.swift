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
//        isHiddenBarBottomLineView = true
        
        let titleTextAtt = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = titleTextAtt
        
        headerView = UIView(frame: CGRect(x: 0, y: 0,
                                          width: view.width,
                                          height: navigationBarHeight))
        headerView?.backgroundColor = .white
        view.addSubview(headerView!)
        
        
        lineView = UIView(frame: CGRect(x: 0, y: headerView!.bottom,
                                            width: view.width, height: 0.5))
        lineView?.backgroundColor = PJRGB(r: 230, g: 230, b: 230)
        view.addSubview(lineView!)
        
        // 解决自定义 leftBarButtonItem 后侧滑失效
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
    

    private func didSetIsHiddenBarBottomLineView() {
        lineView?.isHidden = isHiddenBarBottomLineView!
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
