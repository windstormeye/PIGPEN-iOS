//
//  PJRulerPicker.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/5/16.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJRulerPickerView: UIView {
    
    /// 获取拨动次数
    var moved: ((Int) -> Void)?
    /// 需要拨动的次数
    var pickCount  = 0
    // 中心视图
    private var centerView = UIView()
    private var startIndex = 0
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    convenience init(frame: CGRect, pickCount: Int) {
        
        self.init(frame: frame)
        self.pickCount = pickCount
        initView()
        
    }
    
    private func initView() {
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: pj_width, height: pj_height))
        addSubview(scrollView)
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false

        // 从屏幕左边到屏幕中心占据的个数
        startIndex = (Int(ceil(centerX / 10.5)))
        // 总共需要渲染的子视图加上头尾占据的个数
        pickCount += startIndex * 2 + 1
        
        var finalW: CGFloat = 0
        
        for index in 0..<pickCount {
            
            // 子视图之间的间距
            let inner = 10
            // sv 为每个子视图
            let sv = UIView(frame: CGRect(x: 10 + index * inner, y: Int(scrollView.pj_height / 2), width: 1, height: 4))
            sv.backgroundColor = .lightGray
            sv.tag = index + 100
            scrollView.addSubview(sv)
            
            // 当前子视图是否在中心区域范围内
            if abs(sv.centerX - centerX) < 5 {
                
                sv.pj_height = 18
                sv.pj_width = 2
                sv.backgroundColor = .black
                // 先赋值给中心视图
                centerView = sv
            } else if abs(sv.centerX - centerX) < 16 {
                
                sv.pj_height = 14
                sv.pj_width = 1
            } else if abs(sv.centerX - centerX) < 26 {
                
                sv.pj_height = 8
                sv.pj_width = 1
            } else {
                
                sv.pj_height = 4
                sv.pj_width = 1
            }
            
            sv.y = (scrollView.pj_height - sv.pj_height) * 0.5
            
            if index == pickCount - 1 {
                
                finalW = sv.right
            }
        }
        
        scrollView.contentSize = CGSize(width: finalW, height: 0)
    }
}

extension PJRulerPickerView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offSetX = scrollView.contentOffset.x
        let _ = scrollView.subviews.filter {
            
            if abs($0.centerX - offSetX - centerX) < 5 {
                
                $0.pj_height = 18
                $0.pj_width = 2
                $0.backgroundColor = .black
                
                // 如果本次的中心视图不是上一次的中心视图
                if centerView.tag != $0.tag {
                    
                    PJTapic.select()
                    centerView = $0
                    
                    moved?($0.tag - 100 - startIndex)
                }
            } else if abs($0.centerX - offSetX  - centerX) < 16 {
                
                $0.pj_height = 14
                $0.pj_width = 1
                $0.backgroundColor = .lightGray
            } else if abs($0.centerX - offSetX - centerX) < 26 {
                
                $0.pj_height = 8
                $0.pj_width = 1
                $0.backgroundColor = .lightGray
            } else {
                
                $0.pj_height = 4
                $0.pj_width = 1
                $0.backgroundColor = .lightGray
            }

            $0.y = (scrollView.pj_height - $0.pj_height) * 0.5
            return true
        }
    }
}
