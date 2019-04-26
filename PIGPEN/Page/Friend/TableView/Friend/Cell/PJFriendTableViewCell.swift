//
//  PJFriendTableViewCell.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/26.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJFriendTableViewCell: UITableViewCell {
    var chatButtonClick: (() -> Void)?
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var chatButton: UIButton!
    
    var viewModel: PJUser.FriendModel? {
        didSet { didSetViewModel() }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        let itemW = 25
        let innerW = CGFloat(10)
        collectionViewLayout.itemSize = CGSize(width: itemW , height: itemW)
        collectionViewLayout.minimumLineSpacing = innerW
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: innerW / 2, bottom: 0, right: innerW / 2)
        
        let collectionView = PJLineCollectionView(frame: CGRect(x: nickNameLabel.left, y: pj_height - 30, width: pj_width - chatButton.pj_width - avatarImageView.pj_width, height: 30), collectionViewLayout: collectionViewLayout)
        collectionView.lineType = .icon
        collectionView.viewModels = ["0", "0", "0", "0", "0", "0", "0", "0"]
        addSubview(collectionView)
    }
    
    private func didSetViewModel() {
    }
}
