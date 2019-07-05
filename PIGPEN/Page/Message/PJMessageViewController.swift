//
//  PJMessageViewController.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/5.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJMessageViewController: UIViewController, PJBaseViewControllerDelegate {

    private var tableView = PJMessageTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    private func initView() {
        initBaseView()
        titleString = "娱乐圈s"
        rightBarButtonItem(imageName: "camera", rightSel: .camera)
        
        tableView = PJMessageTableView(frame: CGRect(x: 0, y: navigationBarHeight, width: view.pj_width, height: view.pj_height - navigationBarHeight - PJTABBAR_HEIGHT), style: .plain)
        view.addSubview(tableView)
    }
}

extension PJMessageViewController {
    @objc
    fileprivate func camera() {
        PJInputSelectView.showAlertSheet {
            print($0)
        }
    }
}

private extension Selector {
    static let camera = #selector(PJMessageViewController.camera)
}
