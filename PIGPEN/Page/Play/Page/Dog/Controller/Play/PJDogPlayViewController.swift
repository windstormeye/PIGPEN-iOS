//
//  PJDogPlayViewController.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/13.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit
import CoreMotion

class PJDogPlayViewController: UIViewController, PJBaseViewControllerDelegate {
    var viewModels = [PJPet.Pet]()
    
    private var detailsScrollView = UIScrollView()
    private var detailsScrollViewPage = PJPageControl()
    private var mapView = PJDogPlayMapView()
    
    private var detailsViews = [PJDogPlayDetailsHeaderView]()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
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
        view.backgroundColor = .white
        
        initBaseView()
        titleString = "正在遛狗"
        backButtonTapped(backSel: .back, imageName: nil)
        
        detailsScrollView = UIScrollView(frame: CGRect(x: 15, y: navigationBarHeight + 20, width: view.pj_width - 30, height: 70))
        detailsScrollView.backgroundColor = .white
        detailsScrollView.showsHorizontalScrollIndicator = false
        detailsScrollView.showsVerticalScrollIndicator = false
        detailsScrollView.isPagingEnabled = true
        detailsScrollView.delegate = self
        detailsScrollView.layer.cornerRadius = detailsScrollView.pj_height / 2
        view.addSubview(detailsScrollView)
        
        for (index, pet) in viewModels.enumerated() {
            let dV = PJDogPlayDetailsHeaderView.newInstance()
            dV.frame = CGRect(x: CGFloat(index) * detailsScrollView.pj_width, y: 0, width: detailsScrollView.pj_width, height: detailsScrollView.pj_height)
            dV.viewModel = PJDogPlayDetailsHeaderView.ViewModel()
            dV.viewModel.pet = pet
            
            detailsViews.append(dV)
            detailsScrollView.addSubview(dV)
            detailsScrollView.contentSize = CGSize(width: dV.right, height: 0)
        }
        
        
        detailsScrollViewPage = PJPageControl(frame: CGRect(x: 0, y: Int(detailsScrollView.bottom - 10), width:7 * viewModels.count, height: 7))
        detailsScrollViewPage.centerX = view.centerX
        detailsScrollViewPage.centerX = view.centerX
        detailsScrollViewPage.numberOfPages = viewModels.count
        detailsScrollViewPage.currentPage = 0
        detailsScrollViewPage.setValue(UIImage(named: "pageControl_unselected"), forKey: "_pageImage")
        detailsScrollViewPage.setValue(UIImage(named: "pageControl_selected"), forKey: "_currentPageImage")
        detailsScrollViewPage.addTarget(self, action: .pageControlClick, for: .touchUpInside)
        view.addSubview(detailsScrollViewPage)
        
        
        mapView = PJDogPlayMapView(frame: CGRect(x: 0, y: 0, width: view.pj_width, height: view.pj_height))
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
        
        mapView.updateMsg = {
            for dV in self.detailsViews {
                var viewModel = dV.viewModel
                viewModel.time = $0
                viewModel.distance = $1
                dV.viewModel = viewModel
            }
            
            // TODO: 后续再考虑单独结束遛狗
//            self.detailsViews[self.detailsScrollViewPage.currentPage].viewModel = viewModel
        }
        
        // 停止遛狗
        let stopButton = UIButton(frame: CGRect(x: 0, y: view.pj_height - 36 - 20 - bottomSafeAreaHeight, width: 120, height: 36))
        view.addSubview(stopButton)
        stopButton.setTitle("结束遛狗", for: .normal)
        stopButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        stopButton.backgroundColor = PJRGB(61, 44, 79)
        stopButton.layer.cornerRadius = stopButton.pj_height / 2
        stopButton.centerX = view.centerX
        stopButton.addTarget(self, action: .stop, for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // TODO: 考虑「继续遛狗」的情况
    }
}

extension PJDogPlayViewController {
    @objc
    fileprivate func back() {
        popBack()
    }
    
    @objc
    fileprivate func stop() {
        mapView.stopLocating()
        mapView.stopLocation = {
            let vc = PJDogPlayFinishViewController()
            var viewModels = [PJDogPlayFinishViewController.ViewModel]()
            
            for pet in self.viewModels {
                var vm = PJDogPlayFinishViewController.ViewModel()
                vm.pet = pet
                
                var detailsViewModel = PJDogPlayFinishDetailsView.ViewModel()
                detailsViewModel.mapImage = $0
                detailsViewModel.durations = $1
                detailsViewModel.distance = $2
                detailsViewModel.kcal = CGFloat(Int(distanceToKcal(distance: $2) * 100))
                vm.details = detailsViewModel
                
                viewModels.append(vm)
            }
            
            vc.viewModels = viewModels
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc
    fileprivate func pageControlClick(sender: UIPageControl) {
        detailsScrollView.setContentOffset(CGPoint(x: detailsScrollView.pj_width * CGFloat(sender.currentPage), y: 0), animated: true)
    }
}

extension PJDogPlayViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetX = scrollView.contentOffset.x
        detailsScrollViewPage.currentPage = Int(offSetX / scrollView.pj_width)
    }
}

private extension Selector {
    static let back = #selector(PJDogPlayViewController.back)
    static let stop = #selector(PJDogPlayViewController.stop)
    static let pageControlClick = #selector(PJDogPlayViewController.pageControlClick(sender:))
}
