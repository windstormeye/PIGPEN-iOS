//
//  PJDogPlayHomeViewController.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/20.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJDogPlayHomeViewController: UIViewController, PJBaseViewControllerDelegate {

    var viewModels = [PJPet.Pet]()
    
    private var avatarView = PJPetAvatarView()
    private var bottomView = PJBottomDotButtonView()
    private var detailsViews = [PJCatPlayDetailsView]()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModels: [PJPet.Pet]) {
        self.init(nibName: nil, bundle: nil)
        self.viewModels = viewModels
        initView()
    }
    
    private func initView() {
        initBaseView()
        view.backgroundColor = .white
        titleString = "遛狗"
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
            self.detailsViews.append(detailsView)
            
            scrollView.contentSize = CGSize(width: detailsView.right, height: 0)
        }
        
        
        bottomView = PJBottomDotButtonView(frame: CGRect(x: 0, y: view.pj_height - bottomSafeAreaHeight - 40, width: view.pj_width, height: 36), pageCount: viewModels.count - 1)
        view.addSubview(bottomView)
        
        bottomView.startSelected = {
            let vc = PJCatPlayViewController()
            vc.viewModels = self.viewModels
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        avatarView.itemSelected = { index in
            self.bottomView.updateDot(index)
            scrollView.setContentOffset(CGPoint(x: CGFloat(index) * self.view.pj_width, y: 0), animated: true)
            
            self.requestData(index)
        }
        
        // 页面都初始化完成后，先请求第一个遛狗看板页面数据
        self.requestData(0)
    }

}

extension PJDogPlayHomeViewController {
    /// 请求当前索引的撸猫看板页面数据
    func requestData(_ index: Int) {
        PJPet.shared.getCatPlayDetails(pet: self.viewModels[index], complateHandler: { catPlay in
            let dV = self.detailsViews[index]
            dV.viewModel = catPlay
        }, failedHandler: {
            PJHUD.shared.showError(view: self.view, text: $0.errorMsg)
        })
    }
}

extension PJDogPlayHomeViewController {
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
    static let back = #selector(PJDogPlayHomeViewController.back)
    static let edit = #selector(PJDogPlayHomeViewController.edit)
    static let add = #selector(PJDogPlayHomeViewController.add)
}

extension PJDogPlayHomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let page = offsetX / view.pj_width
        
        avatarView.scrollToButton(Int(page))
        bottomView.updateDot(Int(page))
    }
}
