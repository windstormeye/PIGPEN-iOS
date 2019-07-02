//
//  PJPetEatViewController.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/2.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJPetEatViewController: UIViewController, PJBaseViewControllerDelegate {
    var viewModels = [PJPet.PetEat]()
    var pets = [PJPet.Pet]()
    
    private var foods = 0
    private var currentIndex = 0
    
    var bottomView = PJBottomDotButtonView()
    var avatarView = PJPetAvatarView()
    
    private var detailsViews = [PJPetEatDetailsView]()
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
        titleString = "吃饭"
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
        
        bottomView = PJBottomDotButtonView(frame: CGRect(x: 0, y: view.pj_height - bottomSafeAreaHeight - 36 - 20, width: view.pj_width, height: 36), pageCount: pets.count - 1, centerButtonText: "开始吃饭")
        view.addSubview(bottomView)
        
        bottomView.startSelected = {
            if self.pets.count > 1 {
                PJAlertSheet.showAlertSheet(viewModel: {
                    $0.firstButtonValue = "取消"
                    $0.secondButtonValue = "确认"
                    $0.title = "同时喂食 2 只宠物\n喂食量将会按需求分配给每只宠物"
                }) {
                    switch $0 {
                    case 0:
                        break
                    case 1:
                        self.detailsViews[self.currentIndex].itemSelectedViewHidded = true
                        self.uploadFoods(foods: self.foods)
                    default: break
                    }
                }
            } else {
                self.detailsViews[self.currentIndex].itemSelectedViewHidded = true
                self.uploadFoods(foods: self.foods)
            }
        }
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: navigationBarHeight, width: view.pj_width, height: view.pj_height - navigationBarHeight - (view.pj_height - bottomView.top)))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isUserInteractionEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        view.addSubview(scrollView)
        view.sendSubviewToBack(scrollView)
        
        for index in 0..<pets.count {
            var detailsViewModel = PJPetEatDetailsView.ViewModel()
            detailsViewModel.pet = pets[index]
            
            let detailsView = PJPetEatDetailsView(frame: CGRect(x: CGFloat(index) * scrollView.pj_width, y: 0, width: view.pj_width, height: scrollView.pj_height), viewModel: detailsViewModel)
            scrollView.addSubview(detailsView)
            
            detailsView.editSelected = {
                let vc = PJPetDataEditViewController(viewModels: self.pets, type: .eat)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            detailsView.manualSelected = {
                self.foods = $0
            }
            
            self.detailsViews.append(detailsView)
            scrollView.contentSize = CGSize(width: detailsView.right, height: 0)
            
            requestData(at: index)
        }
    }
}

extension PJPetEatViewController {
    /// 请求当前索引的遛狗看板页面数据
    func requestData(at index: Int) {
        // TODO: 获取过数据就不要在拉取了
        
        PJPet.shared.petTodayEat(pet: pets[index], complateHandler: {
            let dV = self.detailsViews[index]
            var viewModel = PJPetEatDetailsView.ViewModel()
            viewModel.eat = $0
            viewModel.pet = self.pets[index]
            dV.viewModel = viewModel
            
            self.viewModels.append($0)
        }) {
            PJHUD.shared.showError(view: self.view, text: $0.errorMsg)
        }
    }
    
    func update() {
        for index in 0..<pets.count {
            requestData(at: index)
        }
    }
    
    /// 提交喝水信息
    func uploadFoods(foods: Int) {
        guard foods != 0 else { return }
        
        var petFoods = [Int]()
        if pets.count > 1 {
            // 按比例分配宠物进水量
            var totalFoods = 0
            for eat in viewModels {
                totalFoods += eat.food_target_today
            }
            
            for eat in viewModels {
                var petEat = eat.food_target_today
                // 巧妙的除法
                if petEat < totalFoods {
                    petEat *= 10
                    petFoods.append(Int(CGFloat(petEat / totalFoods * foods) * 0.1))
                } else {
                    petFoods.append(petEat / totalFoods * foods)
                }
            }
        } else {
            petFoods = [foods]
        }
        
        PJHUD.shared.showLoading(view: self.view)
        for (index, pet) in pets.enumerated() {
            PJPet.shared.petEatUpload(pet: pet, foods: petFoods[index], complateHandler: {
                if index == self.pets.count - 1 {
                    PJHUD.shared.dismiss()
                    self.update()
                }
            }) {
                PJHUD.shared.showError(view: self.view, text: $0.errorMsg)
            }
        }
    }
}

extension PJPetEatViewController {
    @objc
    fileprivate func back() {
        popBack()
    }
}

private extension Selector {
    static let back = #selector(PJPetEatViewController.back)
}


extension PJPetEatViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let page = Int(offsetX / view.pj_width)
        
        avatarView.scrollToButton(at: page)
        bottomView.updateDot(at: page)
        self.currentIndex = page
    }
}
