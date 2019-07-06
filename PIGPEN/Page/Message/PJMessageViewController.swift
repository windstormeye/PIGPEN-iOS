//
//  PJMessageViewController.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/5.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit
import YPImagePicker

class PJMessageViewController: UIViewController, PJBaseViewControllerDelegate {

    private var tableView = PJMessageTableView()
    private var pet = PJPet.Pet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    private func initView() {
        initBaseView()
        titleString = "娱乐圈"
        rightBarButtonItem(imageName: "camera", rightSel: .camera)
        
        tableView = PJMessageTableView(frame: CGRect(x: 0, y: navigationBarHeight, width: view.pj_width, height: view.pj_height - navigationBarHeight - PJTABBAR_HEIGHT), style: .plain)
        view.addSubview(tableView)
    }
}

extension PJMessageViewController {
    @objc
    fileprivate func camera() {
        PJInputSelectView.showAlertSheet {
            switch $0 {
            case 0:
                let picker = YPImagePicker(configuration: pj_YPImagePicker())
                picker.didFinishPicking { [unowned picker] items, _ in
                    if let photo = items.singlePhoto {
//                        PJHUD.shared.showLoading(view: self.view)
//                        PJImageUploader.upload(assets: [photo.asset!],
//                                               complateHandler: { [weak self] imgUrls,keys in
//                                                guard let `self` = self else { return }
//                                                self.pet.avatar_url = keys[0]
//
//                                                PJHUD.shared.dismiss()
//                        }) { (error) in
//                            PJHUD.shared.showError(view: self.view, text: error.errorMsg)
//                        }
                        
                        let vc = PJMessageInputViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    picker.dismiss(animated: true, completion: nil)
                }
                self.present(picker, animated: true, completion: nil)
            case 1: break
            default: break
            }
        }
    }
}

private extension Selector {
    static let camera = #selector(PJMessageViewController.camera)
}
