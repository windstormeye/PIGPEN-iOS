//
//  PJDogPlayFinishViewController.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/22.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJDogPlayFinishViewController: UIViewController, PJBaseViewControllerDelegate {
 
    var viewModels = [ViewModel]() {
        didSet {
            for vm in viewModels {
                pets.append(vm.pet)
            }
            initView()
        }
    }
    
    private var pets = [PJPet.Pet]()
    private var avatarView = PJPetAvatarView()
    private var detailsViews = [PJDogPlayFinishDetailsView]()
    
    private func initView() {
        view.backgroundColor = .white
        initBaseView()
        titleString = "关于本次遛狗"
        backButtonTapped(backSel: .back, imageName: nil)
        rightBarButtonItem(imageName: "share", rightSel: .share)

        avatarView = PJPetAvatarView(frame: CGRect(x: 20, y: navigationBarHeight, width: view.pj_width - 40, height: 36 * 1.385), viewModel: pets)
        avatarView.scrollToButton(at: 0)
        view.addSubview(avatarView)
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: avatarView.bottom + 5, width: view.pj_width, height: view.pj_height - avatarView.pj_height))
        view.addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        for (index, vm) in viewModels.enumerated() {
            let detailsViewWidth = scrollView.pj_width
            let detailsView = PJDogPlayFinishDetailsView(frame: CGRect(x: CGFloat(index) * detailsViewWidth, y: 0, width: detailsViewWidth, height: view.pj_height - avatarView.bottom - bottomSafeAreaHeight), viewModel: vm.details)
            scrollView.addSubview(detailsView)
            detailsViews.append(detailsView)
            
            detailsView.backSelected = {
                self.navigationController?.popViewController(animated: true)
            }
            detailsView.finishSelected = {
                self.uploadData()
            }
            
            scrollView.contentSize = CGSize(width: detailsView.right, height: 0)
        }
        
        requestData(at: 0)
    }
}

extension PJDogPlayFinishViewController {
    /// 请求当前狗狗的卡路里数据
    func requestData(at index: Int) {
        PJPet.shared.getDogPlayDetails(pet: pets[index], complateHandler: { dogPlay in
            
            var viewModel = PJDogPlayFinishDetailsView.ViewModel()
            viewModel.kcal = self.viewModels[index].details.kcal
            viewModel.distance = self.viewModels[index].details.distance
            viewModel.durations = self.viewModels[index].details.durations
            viewModel.score = CGFloat(Int(CGFloat(Int(self.viewModels[index].details.kcal) + dogPlay.kcal_today) / CGFloat(dogPlay.kcal_target_today) * 100))
            viewModel.mapImage = self.viewModels[index].details.mapImage
            
            self.detailsViews[index].viewModel = viewModel
            
        }, failedHandler: {
            PJHUD.shared.showError(view: self.view, text: $0.errorMsg)
        })
    }
    
    func uploadData() {
        var petIndex = 0
        
        for (index, vm) in viewModels.enumerated() {
            let viewModel = self.detailsViews[index].viewModel
            PJPet.shared.dogPlaUpload(pet: vm.pet, distance: Int(viewModel.distance), durations: detailsViews[index].viewModel.durations, complateHandler: {
                petIndex += 1

                if petIndex == self.detailsViews.count {
                    PJHUD.shared.dismiss()
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }) {
                PJHUD.shared.showError(view: self.view, text: $0.errorMsg)
            }
        }
        
    }
}

extension PJDogPlayFinishViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let page = Int(offsetX / view.pj_width)
        
        
        avatarView.scrollToButton(at: page)
        requestData(at: page)
    }
}

extension PJDogPlayFinishViewController {
    @objc
    fileprivate func back() {
        popBack()
    }
    
    @objc
    fileprivate func share() {
        
    }
}

extension PJDogPlayFinishViewController {
    struct ViewModel {
        var pet: PJPet.Pet
        var details: PJDogPlayFinishDetailsView.ViewModel
        
        init() {
            pet = PJPet.Pet()
            details = PJDogPlayFinishDetailsView.ViewModel()
        }
    }
}

private extension Selector {
    static let back = #selector(PJDogPlayFinishViewController.back)
    static let share = #selector(PJDogPlayFinishViewController.share)
}
