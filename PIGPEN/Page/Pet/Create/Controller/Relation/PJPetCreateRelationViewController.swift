//
//  PJPetCreateRelationViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/5/14.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit
import CollectionKit

class PJPetCreateRelationViewController: UIViewController, PJBaseViewControllerDelegate {
    var petType = PJPet.PetType.dog
    var selected: ((Int, String) -> Void)?
    var selectedIndex = 0
    
    private var collectionView = CollectionView()
    private var relations = ["妈妈", "爸爸", "姥爷", "姥姥", "爷爷", "奶奶", "哥哥", "弟弟", "姐姐", "妹妹" , "叔叔", "阿姨", "其它"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    private func initView() {
        initBaseView()
        backButtonTapped(backSel: .back, imageName: nil)
        rightBarButtonItem(imageName: "ok_0", rightSel: .done)
        view.backgroundColor = .white
        
        switch petType {
        case .dog:
            titleString = "您是狗狗的"
        case .cat:
            titleString = "您是猫咪的"
        }
        
        
        // 初始化布局
        let layout = FlowLayout(lineSpacing: 30, interitemSpacing: 20, justifyContent: .center, alignItems: .start, alignContent: .start).inset(by: UIEdgeInsets(top: 40, left: 20, bottom: 0, right: 20))
        
        // 初始化大小
        let sizeSource = ClosureSizeSource { (index: Int, data: String, size: CGSize) -> CGSize in
            return CGSize(width: 60, height: 90)
        }
        
        let viewSource = ClosureViewSource(viewGenerator: { (data: String, index: Int) -> UIButton in
            // 视图初始化
            let avatarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 90))
            avatarButton.setTitle(data, for: .normal)
            avatarButton.setTitleColor(.black, for: .selected)
            avatarButton.setTitleColor(PJRGB(180, 180, 180), for: .normal)
            avatarButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            avatarButton.setImage(UIImage(named: "pet_relation_\(0)_selected"), for: .selected)
            avatarButton.setImage(UIImage(named: "pet_relation_\(0)"), for: .normal)
            avatarButton.topImageBottomTitle(titleTop: 25)
            avatarButton.addTarget(self, action: .avatarTap, for: .touchUpInside)
            avatarButton.tag = index
            
            if index == self.selectedIndex { avatarButton.isSelected = true }
            return avatarButton
        }, viewUpdater: { (view: UIButton, data: String, index: Int) in
            // 视图更新
            if index != self.selectedIndex {
                view.isSelected = false
            } else {
                view.isSelected = true
            }
        })
        
        
        let provider = BasicProvider(identifier: nil,
                                     dataSource: relations,
                                     viewSource: viewSource,
                                     sizeSource: sizeSource,
                                     layout: layout,
                                     animator: nil)
    
        collectionView = CollectionView(provider: provider)
        collectionView.frame = CGRect(x: 0, y: navigationBarHeight, width: view.pj_width, height: view.pj_height)
        view.addSubview(collectionView)
    }
}

private extension Selector {
    static let back = #selector(PJPetCreateRelationViewController.back)
    static let done = #selector(PJPetCreateRelationViewController.done)
    static let avatarTap = #selector(PJPetCreateRelationViewController.avatarTap(sender:))
}

extension PJPetCreateRelationViewController {
    @objc
    fileprivate func back() {
        popBack()
    }
    
    @objc
    fileprivate func done() {
        selected?(selectedIndex, relations[selectedIndex])
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    fileprivate func avatarTap(sender: UIButton) {
        selectedIndex = sender.tag
        collectionView.setNeedsReload()
    }
}


