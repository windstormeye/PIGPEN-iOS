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
            let detailsView = PJDogPlayFinishDetailsView(frame: CGRect(x: CGFloat(index) * detailsViewWidth, y: 0, width: detailsViewWidth, height: view.pj_height - avatarView.bottom), viewModel: vm.details)
            scrollView.addSubview(detailsView)
            detailsView.backSelected = {
                self.navigationController?.popViewController(animated: true)
            }
            detailsView.finishSelected = {
                self.finish()
            }
            
            scrollView.contentSize = CGSize(width: detailsView.right, height: 0)
        }
    }
}

extension PJDogPlayFinishViewController {
    func finish() {
        
    }
    
    func requestData(at page: Int) {
        
    }
    
    func uploadData() {
        var petIndex = 0
        
        //        for (index, pet) in viewModels.enumerated() {
        //            let viewModel = self.detailsViews[index].viewModel
        //            PJPet.shared.dogPlaUpload(pet: pet, distance: Int(viewModel.distance), complateHandler: {
        //                petIndex += 1
        //
        //                if petIndex == self.detailsViews.count {
        //                    PJHUD.shared.dismiss()
        //                    self.navigationController?.popViewController(animated: true)
        //                }
        //            }) {
        //                PJHUD.shared.showError(view: self.view, text: $0.errorMsg)
        //            }
        //        }
        
    }
}

extension PJDogPlayFinishViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let page = Int(offsetX / view.pj_width)
        
        
        avatarView.scrollToButton(at: page)
//        bottomView.updateDot(at: page)
//        requestData(at: page)
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
