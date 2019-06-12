//
//  PJPlayViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/25.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJPlayViewController: UIViewController, PJBaseViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        initBaseView()
        titleString = "娱乐圈"
        
        view.backgroundColor = .white
        
        let collectionView = PJPlayCollectionView(frame: CGRect(x: 0, y: 0, width: view.pj_width, height: view.pj_height - navigationBarHeight))
        view.addSubview(collectionView)
        collectionView.selectedActivity = {
            switch $0 {
            case 0:
                break
            case 1:
                break
            case 2:
                let vc = PJCatPlayViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        }
    }
}
