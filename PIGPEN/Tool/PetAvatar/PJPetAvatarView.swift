//
//  PJPetAvatarView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/15.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJPetAvatarView: UIView {

    /// 当前选择的宠物头像
    var currentIndex = 0
    var itemSelected: ((Int) -> Void)?
    
    private var pets = [PJPet.Pet]()
    private var scrollView = UIScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, viewModel: [PJPet.Pet]) {
        self.init(frame: frame)
        
        pets = viewModel
        initView()
    }
    
    
    private func initView() {
        backgroundColor = .clear
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: pj_width, height: pj_height))
        addSubview(scrollView)
        
        let innerW = CGFloat(10.0)
        let buttonW = CGFloat(26.0)
        for (index, item) in pets.enumerated() {
            let button = UIButton(frame: CGRect(x: 10 + (innerW + buttonW) * CGFloat(index), y: 0, width: buttonW, height: buttonW))
            button.y = (pj_height - buttonW) / 2
            scrollView.addSubview(button)
            button.layer.cornerRadius = buttonW / 2
            button.clipsToBounds = true
            button.tag = index
            button.imageView?.contentMode = .scaleAspectFill
            button.addTarget(self, action: .tapped, for: .touchUpInside)
            button.kf.setImage(with: URL(string: item.avatar_url), for: .normal)
            
            scrollView.contentSize = CGSize(width: button.right + 20 + 10, height: 0)
        }
    }

    
    /// 放大某个下标的头像，并缩小其它下标的头像（带动画）
    func scrollToButton(at index: Int) {
        
        currentIndex = index
        
        for v in scrollView.subviews {
            if v.tag == index {
                UIView.animate(withDuration: 0.25) {
                    v.transform = CGAffineTransform(scaleX: 1.385, y: 1.385)
                }
            } else {
                if v.pj_width != 26 {
                    UIView.animate(withDuration: 0.25) {
                        v.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }
                }
            }
        }
    }
}

extension PJPetAvatarView {
    @objc
    fileprivate func tapped(sender: UIButton) {
        scrollToButton(at: sender.tag)
        itemSelected?(sender.tag)
    }
}

private extension Selector {
    static let tapped = #selector(PJPetAvatarView.tapped(sender:))
}
