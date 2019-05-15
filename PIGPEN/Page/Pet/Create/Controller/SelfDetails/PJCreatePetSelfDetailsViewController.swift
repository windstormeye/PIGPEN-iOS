//
//  PJCreatePetSelfDetailsViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/5/15.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJCreatePetSelfDetailsViewController: UIViewController, PJBaseViewControllerDelegate {
    var pet = PJPet.Pet()
    // 上传
    var imgKey = ""
    // 关系代码 -1 黑户
    var relation_code = 0

    private var tapicValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        view.backgroundColor = .white
        initBaseView()
        backButtonTapped(backSel: .back, imageName: nil)
        
        switch pet.pet_type {
        case .cat:
            titleString = "添加猫咪"
        case .dog:
            titleString = "添加狗狗"
        }
        

        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 200, width: view.pj_width, height: 100))
        view.addSubview(scrollView)
        
        var finalW: CGFloat = 0
        for index in 0..<100 {
            let inner = 10
            let sv = UIView(frame: CGRect(x: 10 + index * inner, y: Int(scrollView.pj_height / 2), width: 1, height: 4))
            sv.backgroundColor = .lightGray
            scrollView.addSubview(sv)
            
            if abs(sv.centerX - view.centerX) < 5 {
                sv.pj_height = 18
                sv.pj_width = 2
                sv.backgroundColor = .black
            } else if abs(sv.centerX - view.centerX) < 16 {
                sv.pj_height = 14
                sv.pj_width = 1
            } else if abs(sv.centerX - view.centerX) < 26 {
                sv.pj_height = 8
                sv.pj_width = 1
            } else if abs(sv.centerX - view.centerX) < 36 {
                sv.pj_height = 4
                sv.pj_width = 1
            }
            
            sv.y = (scrollView.pj_height - sv.pj_height) * 0.5
            
            if index == 99 {
                finalW = sv.right
            }
        }
        
        scrollView.contentSize = CGSize(width: finalW, height: 0)
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
    }
}

extension PJCreatePetSelfDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetX = scrollView.contentOffset.x
        let offSetXIndex = Int(offSetX / 20)
        
        if offSetXIndex != tapicValue {
            PJTapic.select()
            tapicValue = offSetXIndex
        }
        
        let _ = scrollView.subviews.filter { (sv) -> Bool in
            if abs(sv.centerX - offSetX - view.centerX) < 5 {
                sv.pj_height = 18
                sv.pj_width = 2
                sv.backgroundColor = .black
            } else if abs(sv.centerX - offSetX  - view.centerX) < 16 {
                sv.pj_height = 14
                sv.pj_width = 1
                sv.backgroundColor = .lightGray
            } else if abs(sv.centerX - offSetX - view.centerX) < 26 {
                sv.pj_height = 8
                sv.pj_width = 1
                sv.backgroundColor = .lightGray
            } else if abs(sv.centerX - offSetX - view.centerX) < 36 {
                sv.pj_height = 4
                sv.pj_width = 1
                sv.backgroundColor = .lightGray
            }
            print(sv.centerX - offSetX - view.centerX)
            sv.y = (scrollView.pj_height - sv.pj_height) * 0.5
            return true
        }
        
    }
}

private extension Selector {
    static let back = #selector(PJCreatePetSelfDetailsViewController.back)
    static let done = #selector(PJCreatePetSelfDetailsViewController.done)
}

extension PJCreatePetSelfDetailsViewController {
    @objc
    fileprivate func back() {
        popBack()
    }
    
    @objc
    fileprivate func done() {
        print(pet)
    }
}
