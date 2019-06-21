//
//  PJBottomDotButtonView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/15.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJBottomDotButtonView: UIView {

    var startSelected: (() -> Void)?
    /// 页数
    var pageCount = 0
    /// 当前页数
    var currentPage = 0
    
    private var centerButton = UIButton()
    private let vW = CGFloat(4)
    private let vInnerW = CGFloat(10)
    /// 是否有移动到左边的视图
    private var isLeft = false
    /// 右边视图是否还有内容
    private var isRight = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, pageCount: Int) {
        self.init(frame: frame)
        self.pageCount = pageCount
        initView()
    }
    
    private func initView() {
        centerButton = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: pj_height))
        centerButton.centerX = centerX
        centerButton.setTitle("开始撸猫", for: .normal)
        centerButton.setTitleColor(.white, for: .normal)
        centerButton.addTarget(self, action: .start, for: .touchUpInside)
        centerButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        centerButton.layer.cornerRadius = centerButton.pj_height / 2
        centerButton.clipsToBounds = true
        centerButton.backgroundColor = PJRGB(255, 85, 67)
        centerButton.tag = -1
        addSubview(centerButton)
        
        for index in 0..<pageCount {
            let vX = CGFloat(index) * (vW + vInnerW) + centerButton.right + 10
            let v = UIView(frame: CGRect(x: vX, y: (pj_height - vW) / 2, width: vW, height: vW))
            v.layer.cornerRadius = 2
            v.tag = index
            v.backgroundColor = PJRGB(230, 230, 230)
            addSubview(v)
        }
    }
    
    func updateDot(at index: Int) {
        guard index <= pageCount else { return }
        
        if index == pageCount {
            isRight = false
        }
        if index == 0 {
            isLeft = false
            isRight = true
        }
        
        for (i, v) in subviews.enumerated() {
            guard v.tag >= 0 else { continue }
            
            if v.tag < index {
                v.right = centerButton.left - CGFloat(i) * (vW + vInnerW)
                isLeft = true
            } else {
                if isLeft && isRight {
                    v.x -= (vW + vInnerW)
                } else {
                    if index == 0 {
                        v.x = CGFloat(v.tag) * (vW + vInnerW) + centerButton.right + 10
                    } else {
                        v.x = CGFloat(v.tag) * (vW + vInnerW) + centerButton.right
                    }
                }
            }
        }
        
        currentPage = index
    }
}

extension PJBottomDotButtonView {
    @objc
    fileprivate func start() {
        startSelected?()
    }
}

private extension Selector {
    static let start = #selector(PJBottomDotButtonView.start)
}
