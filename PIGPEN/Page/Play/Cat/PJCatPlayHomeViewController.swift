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
    private var detailsViews = [PJPetPlayHomeDetailsView]()
    
    
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
        avatarView.scrollToButton(at: 0)
        view.addSubview(avatarView)
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: navigationBarHeight, width: view.pj_width, height: view.pj_height - navigationBarHeight))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        view.addSubview(scrollView)
        view.sendSubviewToBack(scrollView)
        
        for index in 0..<viewModels.count {
            let detailsView = PJPetPlayHomeDetailsView(frame: CGRect(x: CGFloat(index) * view.pj_width, y: 0, width: view.pj_width, height: scrollView.pj_height))
            scrollView.addSubview(detailsView)
            self.detailsViews.append(detailsView)
            
            scrollView.contentSize = CGSize(width: detailsView.right, height: 0)
        }
        
        
        bottomView = PJBottomDotButtonView(frame: CGRect(x: 0, y: view.pj_height - bottomSafeAreaHeight - 36 - 20, width: view.pj_width, height: 36), pageCount: viewModels.count - 1, centerButtonText: "开始撸猫")
        view.addSubview(bottomView)
        
        bottomView.startSelected = {
            let vc = PJCatPlayViewController()
            vc.viewModels = self.viewModels
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        avatarView.itemSelected = { index in
            self.bottomView.updateDot(at: index)
            scrollView.setContentOffset(CGPoint(x: CGFloat(index) * self.view.pj_width, y: 0), animated: true)
            
            self.requestData(at: index)
        }
        
        // 页面都初始化完成后，先请求第一个撸猫看板页面数据
        self.requestData(at: 0)
    }
}

extension PJCatPlayHomeViewController {
    /// 请求当前索引的撸猫看板页面数据
    func requestData(at index: Int) {
        // 获取过数据就不要在拉取了
        guard detailsViews[index].viewModel.catPlay == nil else { return }
        
        PJPet.shared.getCatPlayDetails(pet: self.viewModels[index], complateHandler: { catPlay in
            let dV = self.detailsViews[index]
            var viewModel = PJPetPlayHomeDetailsView.ViewModel()
            viewModel.catPlay = catPlay
            dV.viewModel = viewModel
        }, failedHandler: {
            PJHUD.shared.showError(view: self.view, text: $0.errorMsg)
        })
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let page = Int(offsetX / view.pj_width)
        
        avatarView.scrollToButton(at: page)
        bottomView.updateDot(at: page)
        requestData(at: page)
    }
}
