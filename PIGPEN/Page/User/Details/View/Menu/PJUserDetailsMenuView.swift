//
//  PJUserDetailsMenuView.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/5.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit


protocol PJUserDetailsMenuViewDelegate: class {
    func PJUserDetailsMenuViewUpdateUserInfoTapped()
    func PJUserDetailsMenuViewShareButtonTaaped()
    func PJUserDetailsMenuViewBlackNameButtonTapped()
    func PJUserDetailsMenuViewLogoutButtonTapped()
    func PJUserDetailsMenuViewAboutMeButtonTapped()
}

extension PJUserDetailsMenuViewDelegate {
    func PJUserDetailsMenuViewUpdateUserInfoTapped() {}
    func PJUserDetailsMenuViewShareButtonTaaped() {}
    func PJUserDetailsMenuViewBlackNameButtonTapped() {}
    func PJUserDetailsMenuViewLogoutButtonTapped() {}
    func PJUserDetailsMenuViewAboutMeButtonTapped() {}
}


class PJUserDetailsMenuView: UIView {

    var viewDelegate: PJUserDetailsMenuViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = PJRGB(r: 200, g: 200, b: 200).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 5
    }
    
    // MARK:- 创建视图
    class func newInstance() -> PJUserDetailsMenuView? {
        let nibView = Bundle.main.loadNibNamed("PJUserDetailsMenuView",
                                               owner: self,
                                               options: nil);
        if let view = nibView?.first as? PJUserDetailsMenuView {
            return view
        }
        return nil
    }
    
    @IBAction func updateUserInfoButtonTapped(_ sender: UIButton) {
        viewDelegate?.PJUserDetailsMenuViewShareButtonTaaped()
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        viewDelegate?.PJUserDetailsMenuViewShareButtonTaaped()
    }
    
    @IBAction func blackNameButtonTapped(_ sender: UIButton) {
        viewDelegate?.PJUserDetailsMenuViewBlackNameButtonTapped()
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        viewDelegate?.PJUserDetailsMenuViewLogoutButtonTapped()
    }
    
    @IBAction func aboutMeButtonTapped(_ sender: UIButton) {
        viewDelegate?.PJUserDetailsMenuViewAboutMeButtonTapped()
    }
}
