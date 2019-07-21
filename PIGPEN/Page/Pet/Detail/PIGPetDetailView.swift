//
//  PIGPetDetailView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/21.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PIGPetDetailViewController: UIViewController, PJBaseViewControllerDelegate {
    private var pet = PJPet.Pet()
    private var avatarImage = UIImage()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(pet: PJPet.Pet, avatarImage: UIImage) {
        self.init(nibName: nil, bundle: nil)
        self.pet = pet
        self.avatarImage = avatarImage
        initView()
    }
    
    private func initView() {
        view.backgroundColor = .white
        
        initBaseView()
        titleString = pet.nick_name
        backButtonTapped(backSel: .back)
        
        let avatarImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: view.pj_width - 20, height: view.pj_width - 20))
        avatarImageView.image = self.avatarImage
        view.addSubview(avatarImageView)
        avatarImageView.layer.cornerRadius = 5
        
        let infoView = PIGPetDetailInfoView.newInstance()
        infoView.frame = CGRect(x: 0, y: avatarImageView.bottom, width: view.pj_width, height: 50)
        view.addSubview(infoView)
    }

}

extension PIGPetDetailViewController {
    @objc
    fileprivate func back() {
        popBack()
    }
}

private extension Selector {
    static let back = #selector(PIGPetDetailViewController.back)
}
