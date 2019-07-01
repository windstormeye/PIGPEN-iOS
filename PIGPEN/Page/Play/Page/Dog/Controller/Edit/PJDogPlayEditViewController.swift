//
//  PJDogPlayEditViewController.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/23.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJPetDataEditViewController: UIViewController, PJBaseViewControllerDelegate {

    var viewModels = [PJPet.Pet]()
    var tableViews = [PJDogPlayEditTableView]()
    var type: PJDogPlayEditTableView.TableViewType = .play
    
    private var avatarView = PJPetAvatarView()
    private var scrollView = UIScrollView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModels: [PJPet.Pet], type: PJDogPlayEditTableView.TableViewType) {
        self.init(nibName: nil, bundle: nil)
        self.viewModels = viewModels
        self.type = type
        initView()
    }
    
    private func initView() {
        view.backgroundColor = .white
        initBaseView()
        titleString = "修改遛狗记录"
        backButtonTapped(backSel: .back, imageName: nil)
        
        avatarView = PJPetAvatarView(frame: CGRect(x: 20, y: navigationBarHeight, width: view.pj_width - 40, height: 36 * 1.385), viewModel: viewModels)
        avatarView.scrollToButton(at: 0)
        view.addSubview(avatarView)
        avatarView.itemSelected = {
            self.requestData(at: $0, page: 1)
            self.scrollView.setContentOffset(CGPoint(x: CGFloat($0) * self.view.pj_width, y: 0), animated: true)
        }
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: avatarView.bottom + 5, width: view.pj_width, height: view.pj_height - avatarView.pj_height))
        view.addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        for index in 0..<viewModels.count {
            let tableView = PJDogPlayEditTableView(frame: CGRect(x: CGFloat(index) * scrollView.pj_width, y: 0, width: scrollView.pj_width, height: scrollView.pj_height), style: .plain, type: type)
            scrollView.addSubview(tableView)
            tableViews.append(tableView)
            
            scrollView.contentSize = CGSize(width: tableView.right, height: 0)
        }
        
        requestData(at: 0, page: 1)
    }
}

extension PJPetDataEditViewController {
    func requestData(at index: Int, page: Int) {
        
        guard tableViews[index].viewModels.count == 0 else { return }
        
        switch type {
        case .play:
            PJPet.shared.dogPlayHistory(pet: viewModels[index], page: page, complateHandler: {
                self.tableViews[index].convertPlayData(datas: $0)
            }) {
                PJHUD.shared.show(view: self.view, text: $0.errorMsg)
            }
        case .drink:
            PJPet.shared.petDrinkHistory(pet: viewModels[index], complateHandler: {
                self.tableViews[index].convertDrinkData(datas: $0)
            }) {
                PJHUD.shared.show(view: self.view, text: $0.errorMsg)
            }
        }
    }
}

extension PJPetDataEditViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let page = Int(offsetX / view.pj_width)
        
        avatarView.scrollToButton(at: page)
        requestData(at: page, page: 1)
    }
}

extension PJPetDataEditViewController {
    @objc
    fileprivate func back() {
        popBack()
    }
}

private extension Selector {
    static let back = #selector(PJPetDataEditViewController.back)
}
