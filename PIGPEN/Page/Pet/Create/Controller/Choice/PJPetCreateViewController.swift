//
//  PJPetCreateViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/5/9.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJPetCreateViewController: UIViewController, PJBaseViewControllerDelegate {

    @IBOutlet private weak var createDogButton: UIButton!
    @IBOutlet private weak var createCatButton: UIButton!
    @IBOutlet private weak var createCheckedPetButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        initBaseView()
        titleString = "添加宠物"
        backButtonTapped(backSel: .back, imageName: nil)
        
        createDogButton.topImageBottomTitle(titleTop: 80)
        createCatButton.topImageBottomTitle(titleTop: 80)
        
        let str = NSMutableAttributedString(string: createCheckedPetButton.currentTitle!)
        let strRange = NSRange.init(location: 0, length: str.length)
        let number = NSNumber(integerLiteral: NSUnderlineStyle.single.rawValue)
        str.addAttributes([NSAttributedString.Key.underlineStyle: number,
                           NSAttributedString.Key.foregroundColor: UIColor.black,
                           NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: strRange)
        createCheckedPetButton.setAttributedTitle(str, for: .normal)
    }
    
    @objc
    fileprivate func back() {
        popBack()
    }
    
    @IBAction
    fileprivate func choicePetType(_ sender: UIButton) {
        let vc = UIStoryboard(name: "PJPetCreateNameViewController", bundle: nil).instantiateViewController(withIdentifier: "PJPetCreateNameViewController") as! PJPetCreateNameViewController
        
        if sender.tag == 1000 {
            vc.petType = .dog
        } else {
            vc.petType = .cat
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

private extension Selector {
    static let back = #selector(PJPetCreateViewController.back)
    static let choiceType = #selector(PJPetCreateViewController.choicePetType(_:))
}
