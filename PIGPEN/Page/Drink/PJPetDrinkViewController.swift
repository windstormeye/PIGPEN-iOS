//
//  PJPetDrinkViewController.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/1.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJPetDrinkViewController: UIViewController, PJBaseViewControllerDelegate {

    var viewModels = [PJPet.PetDrink]()
    var pets = [PJPet.Pet]()
    
    private var waters = 0
    private var currentIndex = 0
    
    var bottomView = PJBottomDotButtonView()
    var avatarView = PJPetAvatarView()
    
    private var detailsViews = [PJPetDrinkDetailsView]()
    private var scrollView = UIScrollView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModels: [PJPet.Pet]) {
        self.init(nibName: nil, bundle: nil)
        self.pets = viewModels
        initView()
    }

    private func initView() {
        view.backgroundColor = .white
        
        initBaseView()
        titleString = "喝水"
        backButtonTapped(backSel: .back, imageName: nil)
        
        avatarView = PJPetAvatarView(frame: CGRect(x: 20, y: navigationBarHeight, width: view.pj_width - 40, height: 36 * 1.385), viewModel: pets)
        avatarView.scrollToButton(at: 0)
        view.addSubview(avatarView)
        avatarView.itemSelected = {
            self.currentIndex = $0
            self.requestData(at: $0)
            self.bottomView.updateDot(at: $0)
            self.scrollView.setContentOffset(CGPoint(x: self.scrollView.pj_width * CGFloat($0), y: 0), animated: true)
        }
        
        bottomView = PJBottomDotButtonView(frame: CGRect(x: 0, y: view.pj_height - bottomSafeAreaHeight - 36 - 20, width: view.pj_width, height: 36), pageCount: pets.count - 1, centerButtonText: "开始喝水")
        view.addSubview(bottomView)
        
        bottomView.startSelected = {
            self.detailsViews[self.currentIndex].itemSelectedViewHidded = true
            self.uploadWaters(index: self.currentIndex, waters: self.waters)
        }
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: navigationBarHeight, width: view.pj_width, height: view.pj_height - navigationBarHeight - (view.pj_height - bottomView.top)))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isUserInteractionEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        view.addSubview(scrollView)
        view.sendSubviewToBack(scrollView)
        
        for index in 0..<pets.count {
            var detailsViewModel = PJPetDrinkDetailsView.ViewModel()
            detailsViewModel.pet = pets[index]
            
            let detailsView = PJPetDrinkDetailsView(frame: CGRect(x: CGFloat(index) * scrollView.pj_width, y: 0, width: view.pj_width, height: scrollView.pj_height), viewModel: detailsViewModel)
            scrollView.addSubview(detailsView)
            
            detailsView.editSelected = {
                let vc = PJPetDataEditViewController(viewModels: self.pets, type: .drink)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            detailsView.manualSelected = {
                self.waters = $0
            }
            
            self.detailsViews.append(detailsView)
            scrollView.contentSize = CGSize(width: detailsView.right, height: 0)
        }
        

        
        requestData(at: 0)
    }
}

extension PJPetDrinkViewController {
    /// 请求当前索引的遛狗看板页面数据
    func requestData(at index: Int) {
        // TODO: 获取过数据就不要在拉取了
        
        PJPet.shared.petTodayDrink(pet: pets[index], complateHandler: {
            let dV = self.detailsViews[index]
            var viewModel = PJPetDrinkDetailsView.ViewModel()
            viewModel.drink = $0
            viewModel.pet = self.pets[index]
            dV.viewModel = viewModel
        }) {
            PJHUD.shared.showError(view: self.view, text: $0.errorMsg)
        }
    }
    
    /// 提交喝水信息
    func uploadWaters(index: Int, waters: Int) {
        guard waters != 0 else { return }
        
        PJHUD.shared.showLoading(view: self.view)
        PJPet.shared.petDrinkUpload(pet: pets[index], waters: waters, complateHandler: {
            PJHUD.shared.dismiss()
            self.requestData(at: index)
        }) {
            PJHUD.shared.showError(view: self.view, text: $0.errorMsg)
        }
    }
}

extension PJPetDrinkViewController {
    @objc
    fileprivate func back() {
        popBack()
    }
}

private extension Selector {
    static let back = #selector(PJPetDrinkViewController.back)
}


extension PJPetDrinkViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let page = Int(offsetX / view.pj_width)
        
        avatarView.scrollToButton(at: page)
        bottomView.updateDot(at: page)
        requestData(at: page)
        self.currentIndex = page
    }
}
