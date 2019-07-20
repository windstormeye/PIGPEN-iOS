//
//  PJSpace+UIScrollView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/21.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

extension UIScrollView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let footerView = scrollView.subviews.filter({ (view) -> Bool in
            return view.tag == 970509
        }).first else { return }
        
        if scrollView.contentSize.height - scrollView.contentOffset.y <= scrollView.pj_height {
//            footerView.isHidden = false
            
            if scrollView.contentSize.height - scrollView.contentOffset.y + 50 > scrollView.pj_height {
                let bottomViewOffSetY = scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.pj_height)
                footerView.top = scrollView.bottom - bottomViewOffSetY
            } else {
                footerView.top = scrollView.bottom - 50
            }
        } else {
            let bottomViewOffSetY = scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.pj_height)
            footerView.top = scrollView.bottom - bottomViewOffSetY
//            footerView.isHidden = true
        }
    }
}

extension PJSpaceWrapper where T: UIScrollView {
    
    @discardableResult
    func setFooterView() -> UIView {
        let bottomView = UIView(frame: CGRect(x: 0, y: 100, width: t.pj_width, height: 50))
        bottomView.tag = 970509
        
        let tipLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomView.addSubview(tipLabel)
        bottomView.isHidden = false
        tipLabel.text = "正在加载..."
        tipLabel.textAlignment = .center
        tipLabel.textColor = PJRGB(200, 200, 200)
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.sizeToFit()
        tipLabel.centerX = t.centerX
        tipLabel.y = (tipLabel.superview!.pj_height - tipLabel.pj_height) / 2
        
        let indicatorView = UIActivityIndicatorView(style: .gray)
        indicatorView.pj_width = 10
        indicatorView.pj_height = 10
        indicatorView.right = tipLabel.left - 5
        tipLabel.left += 15
        bottomView.addSubview(indicatorView)
        indicatorView.y = (indicatorView.superview!.pj_height - indicatorView.pj_height) / 2
        indicatorView.startAnimating()
        
        t.addSubview(bottomView)
        t.contentInset.bottom = 50
        
        t.delegate = t
    
//        _ = t.observe(\.contentOffset.y) { (nT, _) in
//            if nT.contentSize.height - nT.contentOffset.y <= nT.pj_height {
//                bottomView.isHidden = false
//
//                if nT.contentSize.height - nT.contentOffset.y + 50 > nT.pj_height {
//                    let bottomViewOffSetY = nT.contentOffset.y - (nT.contentSize.height - nT.pj_height)
//                    bottomView.top = nT.bottom - bottomViewOffSetY
//                } else {
//                    bottomView.top = nT.bottom - 50
//                }
//            } else {
//                let bottomViewOffSetY = nT.contentOffset.y - (nT.contentSize.height - nT.pj_height)
//                bottomView.top = nT.bottom - bottomViewOffSetY
//                bottomView.isHidden = true
//            }
//        }
        
        return bottomView
    }
}
