//
//  PJUserInfoSeleteAvatarView.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/1.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit


fileprivate extension Selector {
    static let closeButtonTapped = #selector(PJUserInfoSeleteAvatarView.closeButtonTapped)
    static let viewTapped = #selector(PJUserInfoSeleteAvatarView.viewTapped)
}

protocol PJUserInfoSeleteAvatarViewDelegate: class {
    func PJUserInfoSeleteAvatarViewCloseButtonTapped()
    func PJUserInfoSeleteAvatarViewAvatarTag(tag: Int)
    func PJUserInfoSeleteAvatarViewTapped()
}

extension PJUserInfoSeleteAvatarViewDelegate {
    func PJUserInfoSeleteAvatarViewCloseButtonTapped() {}
    func PJUserInfoSeleteAvatarViewAvatarTag(tag: Int) {}
    func PJUserInfoSeleteAvatarViewTapped() {}
}

class PJUserInfoSeleteAvatarView: UIView, PJUserInfoAvatarSelectCollectionViewDelegate {

    var backView: PJBaseTipsView!
    var closeButton: UIButton!
    var avatarCollectionView: PJUserInfoAvatarSelectCollectionView!
    
    weak var viewDelegate: PJUserInfoSeleteAvatarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    private func initView() {
        let tappView = UIView(frame: frame)
        addSubview(tappView)
        
        let viewTapped = UITapGestureRecognizer(target: self, action: .viewTapped)
        tappView.addGestureRecognizer(viewTapped)
        
        backView = PJBaseTipsView(frame: CGRect(x: width * 0.05, y: 40,
                                        width: width * 0.9,
                                        height: height * 0.7))
        backView.backgroundColor = .white
        addSubview(backView)
        
        
        closeButton = UIButton(frame: CGRect(x: 0, y: backView.bottom + 20,
                                             width: 30, height: 30))
        closeButton.centerX = centerX
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.addTarget(self, action: .closeButtonTapped,
                              for: .touchUpInside)
        addSubview(closeButton)
        
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        let itemW = backView.width / 4
        collectionViewLayout.itemSize = CGSize(width: itemW , height: itemW)
        collectionViewLayout.minimumLineSpacing = 20
        collectionViewLayout.minimumInteritemSpacing = 10
        
        let collectionViewRect = CGRect(x: backView.width * 0.05,
                                        y: backView.height * 0.05,
                                        width: backView.width * 0.9,
                                        height: backView.height * 0.9)
        avatarCollectionView = PJUserInfoAvatarSelectCollectionView(frame: collectionViewRect,
                                                                  collectionViewLayout: collectionViewLayout)
        avatarCollectionView.viewDelegate = self
//        avatarCollectionView.alwaysBounceVertical = true
        backView.addSubview(avatarCollectionView)
    }
    
    
    // MARK: Action
    @objc fileprivate func closeButtonTapped() {
        viewDelegate?.PJUserInfoSeleteAvatarViewCloseButtonTapped()
    }
    
    @objc fileprivate func viewTapped() {
        viewDelegate?.PJUserInfoSeleteAvatarViewTapped()
    }
    
    
    // MARK: delegate
    func PJUserInfoAvatarSelectCollectionViewDidSelected(collectionView: PJUserInfoAvatarSelectCollectionView,
                                                         indexPath: IndexPath) {
        viewDelegate?.PJUserInfoSeleteAvatarViewAvatarTag(tag: indexPath.row)
    }
}
