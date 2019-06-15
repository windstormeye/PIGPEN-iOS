//
//  PJCatPlayHomeViewController.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/15.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJCatPlayHomeViewController: UIViewController, PJBaseViewControllerDelegate {

    var viewModels = [PJPet.Pet]()
    
    private var avatarView = PJPetAvatarView()
    private var bottomView = PJBottomDotButtonView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(viewModels: [PJPet.Pet]) {
        self.init(nibName: nil, bundle: nil)
        self.viewModels = viewModels
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        initBaseView()
        view.backgroundColor = .white
        titleString = "撸猫"
        backButtonTapped(backSel: .back, imageName: nil)
        
        avatarView = PJPetAvatarView(frame: CGRect(x: 20, y: navigationBarHeight, width: view.pj_width - 40, height: 36 * 1.385), viewModel: viewModels)
        avatarView.scrollToButton(0)
        view.addSubview(avatarView)
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: navigationBarHeight, width: view.pj_width, height: view.pj_height - navigationBarHeight))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        view.addSubview(scrollView)
        view.sendSubviewToBack(scrollView)
        
        for index in 0..<viewModels.count {
            let detailsView = PJCatPlayDetailsView(frame: CGRect(x: CGFloat(index) * view.pj_width, y: 0, width: view.pj_width, height: scrollView.pj_height))
            scrollView.addSubview(detailsView)
            
            scrollView.contentSize = CGSize(width: detailsView.right, height: 0)
        }
        
        
        bottomView = PJBottomDotButtonView(frame: CGRect(x: 0, y: view.pj_height - bottomSafeAreaHeight - 40, width: view.pj_width, height: 36), pageCount: viewModels.count - 1)
        view.addSubview(bottomView)
        
        avatarView.itemSelected = {
            self.bottomView.updateDot($0)
            scrollView.setContentOffset(CGPoint(x: CGFloat($0) * self.view.pj_width, y: 0), animated: true)
        }
    }
}

extension PJCatPlayHomeViewController {
    @objc
    fileprivate func back() {
        popBack()
    }
    
    @objc
    fileprivate func edit() {
        
    }
    
    @objc
    fileprivate func add() {
        
    }
}

private extension Selector {
    static let back = #selector(PJCatPlayHomeViewController.back)
    static let edit = #selector(PJCatPlayHomeViewController.edit)
    static let add = #selector(PJCatPlayHomeViewController.add)
}

extension PJCatPlayHomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let page = offsetX / view.pj_width
        
        avatarView.scrollToButton(Int(page))
        bottomView.updateDot(Int(page))
    }
}
