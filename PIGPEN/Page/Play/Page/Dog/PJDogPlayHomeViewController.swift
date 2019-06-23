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
    private var detailsViews = [PJPetPlayHomeDetailsView]()

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
        avatarView.scrollToButton(at: 0)
        view.addSubview(avatarView)
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: navigationBarHeight, width: view.pj_width, height: view.pj_height - navigationBarHeight))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isUserInteractionEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        view.addSubview(scrollView)
        view.sendSubviewToBack(scrollView)
        
        for index in 0..<viewModels.count {
            var detailsViewModel = PJPetPlayHomeDetailsView.ViewModel()
            detailsViewModel.pet = viewModels[index]
            
            let detailsView = PJPetPlayHomeDetailsView(frame: CGRect(x: CGFloat(index) * scrollView.pj_width, y: 0, width: view.pj_width, height: scrollView.pj_height), viewModel: detailsViewModel)
            scrollView.addSubview(detailsView)
            
            detailsView.editSelected = {
                let vc = PJDogPlayEditViewController(viewModels: self.viewModels)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            self.detailsViews.append(detailsView)
            scrollView.contentSize = CGSize(width: detailsView.right, height: 0)
        }
        
        
        bottomView = PJBottomDotButtonView(frame: CGRect(x: 0, y: view.pj_height - bottomSafeAreaHeight - 36 - 20, width: view.pj_width, height: 36), pageCount: viewModels.count - 1, centerButtonText: "开始遛狗")
        view.addSubview(bottomView)
        
        bottomView.startSelected = {
            let vc = PJDogPlayViewController(viewModels: self.viewModels)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        avatarView.itemSelected = { index in
            self.bottomView.updateDot(at: index)
            scrollView.setContentOffset(CGPoint(x: CGFloat(index) * self.view.pj_width, y: 0), animated: true)
            
            self.requestData(at: index)
        }
        
        // 页面都初始化完成后，先请求第一个遛狗看板页面数据
        self.requestData(at: 0)
    }

}

extension PJDogPlayHomeViewController {
    /// 请求当前索引的遛狗看板页面数据
    func requestData(at index: Int) {
        // 获取过数据就不要在拉取了
        guard detailsViews[index].viewModel.dogPlay == nil else { return }
        
        PJPet.shared.getDogPlayDetails(pet: self.viewModels[index], complateHandler: { dogPlay in
            let dV = self.detailsViews[index]
            var viewModel = PJPetPlayHomeDetailsView.ViewModel()
            viewModel.dogPlay = dogPlay
            viewModel.pet = self.viewModels[index]
            dV.viewModel = viewModel
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
}

private extension Selector {
    static let back = #selector(PJDogPlayHomeViewController.back)
}

extension PJDogPlayHomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let page = Int(offsetX / view.pj_width)
        
        avatarView.scrollToButton(at: page)
        bottomView.updateDot(at: page)
        requestData(at: page)
    }
}
