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
    
    private var detailsScrollView = UIScrollView()
    private var detailsScrollViewPage = PJPageControl()
    private var mapView = PJDogPlayMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
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
        
        let dogDetailsView = PJDogPlayDetailsView.newInstance()
        dogDetailsView.frame = CGRect(x: 0, y: 0, width: detailsScrollView.pj_width, height: detailsScrollView.pj_height)
        detailsScrollView.addSubview(dogDetailsView)
        
        let dogDetailsView1 = PJDogPlayDetailsView.newInstance()
        dogDetailsView1.frame = CGRect(x: dogDetailsView.right, y: 0, width: detailsScrollView.pj_width, height: detailsScrollView.pj_height)
        detailsScrollView.addSubview(dogDetailsView1)
        
        let dogDetailsView2 = PJDogPlayDetailsView.newInstance()
        dogDetailsView2.frame = CGRect(x: dogDetailsView1.right, y: 0, width: detailsScrollView.pj_width, height: detailsScrollView.pj_height)
        detailsScrollView.addSubview(dogDetailsView2)
        
        detailsScrollView.contentSize = CGSize(width: dogDetailsView2.right, height: 0)
        
        detailsScrollViewPage = PJPageControl(frame: CGRect(x: 0, y: detailsScrollView.bottom - 10, width:50, height: 7))
        detailsScrollViewPage.centerX = view.centerX
        detailsScrollViewPage.numberOfPages = 3
        detailsScrollViewPage.currentPage = 0
        detailsScrollViewPage.setValue(UIImage(named: "pageControl_unselected"), forKey: "_pageImage")
        detailsScrollViewPage.setValue(UIImage(named: "pageControl_selected"), forKey: "_currentPageImage")
        detailsScrollViewPage.addTarget(self, action: .pageControlClick, for: .touchUpInside)
        view.addSubview(detailsScrollViewPage)
        
        
        mapView = PJDogPlayMapView(frame: CGRect(x: 0, y: 0, width: view.pj_width, height: view.pj_height))
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
        
        // 停止撸猫
        let stopButton = UIButton(frame: CGRect(x: 0, y: view.pj_height - 36 - 20 - bottomSafeAreaHeight, width: 120, height: 36))
        view.addSubview(stopButton)
        stopButton.setTitle("结束遛狗", for: .normal)
        stopButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        stopButton.backgroundColor = PJRGB(61, 44, 79)
        stopButton.layer.cornerRadius = stopButton.pj_height / 2
        stopButton.centerX = view.centerX
        stopButton.addTarget(self, action: .stop, for: .touchUpInside)
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
