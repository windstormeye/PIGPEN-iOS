//
//  PJDogPlayEditViewController.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/23.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJDogPlayEditViewController: UIViewController, PJBaseViewControllerDelegate {

    var viewModels = [PJPet.Pet]()
    
    private var avatarView = PJPetAvatarView()
    
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
        view.backgroundColor = .white
        initBaseView()
        titleString = "修改遛狗记录"
        backButtonTapped(backSel: .back, imageName: nil)
        
        avatarView = PJPetAvatarView(frame: CGRect(x: 20, y: navigationBarHeight, width: view.pj_width - 40, height: 36 * 1.385), viewModel: viewModels)
        avatarView.scrollToButton(at: 0)
        view.addSubview(avatarView)
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: avatarView.bottom + 5, width: view.pj_width, height: view.pj_height - avatarView.pj_height))
        view.addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        for (index, vm) in viewModels.enumerated() {
            let detailsViewWidth = scrollView.pj_width
//            let detailsView = PJDogPlayFinishDetailsView(frame: CGRect(x: CGFloat(index) * detailsViewWidth, y: 0, width: detailsViewWidth, height: detailsViewWidth), viewModel: vm.details)
//            scrollView.addSubview(detailsView)
            
//            scrollView.contentSize = CGSize(width: detailsView.right, height: 0)
        }

    }
}

extension PJDogPlayEditViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let page = Int(offsetX / view.pj_width)
        
        avatarView.scrollToButton(at: page)
        //        requestData(at: page)
    }
}

extension PJDogPlayEditViewController {
    @objc
    fileprivate func back() {
        popBack()
    }
}

private extension Selector {
    static let back = #selector(PJDogPlayEditViewController.back)
}
