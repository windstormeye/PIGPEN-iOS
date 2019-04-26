//
//  PJSegmentView.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/1/4.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJSegmentView: UIView {
    // MARK: - Public Properties
    var viewModel: ViewModel? {
        didSet { initView() }
    }
    
    var selected: ((Int) -> Void)?
    
    // MARK: - Private Properties
    let marginR = 20
    var line = UIView()

    // MARK: - Private Methods
    // MARK: - Life Cycle
    private func initView() {
        guard let viewModel = viewModel else { return }
        
        line.frame = CGRect(x: 0, y: self.pj_height - 10, width: 0, height: 2)
        line.pj_width = CGFloat(viewModel.titles[0].count * 15)
        line.backgroundColor = .darkGray
        line.layer.cornerRadius = 1
        addSubview(line)
        
        let itemW = PJSCREEN_WIDTH / CGFloat(viewModel.titles.count)
        self.backgroundColor = viewModel.backgroundColor
        
        for (index, title) in viewModel.titles.enumerated() {
            let titleButton_X = CGFloat(index) * itemW
            let titleButton = UIButton(frame: CGRect(x: CGFloat(titleButton_X),
                                                     y: CGFloat(0),
                                                     width: itemW,
                                                     height: self.pj_height))
            titleButton.setTitle(title, for: .normal)
            titleButton.setTitleColor(viewModel.textColor, for: .normal)
            titleButton.titleLabel?.font = UIFont.systemFont(ofSize: viewModel.fontSize, weight: .regular)
            titleButton.addTarget(self, action: .btnTapped, for: .touchUpInside)
            titleButton.tag = index
            addSubview(titleButton)
            
            if index == 0 {
                line.centerX = titleButton.centerX
            }
        }
    }
}

fileprivate extension Selector {
    static let btnTapped = #selector(PJSegmentView.btnTapped(button:))
}

extension PJSegmentView {
    @objc fileprivate func btnTapped(button: UIButton) {
        UIView.animate(withDuration: 0.25) {
            self.line.pj_width = CGFloat((button.titleLabel?.text?.count ?? 0) * 15)
            self.line.centerX = button.centerX
        }
        
        selected?(button.tag)
    }
}

extension PJSegmentView {
    struct ViewModel {
        /// 标题文本集合
        let titles: [String]
        /// 文本是否聚集在一屏中，默认不滑动
        let isScroll: Bool = true
        /// 标题颜色，默认黑色
        let textColor: UIColor = .black
        /// 背景颜色，默认白色
        let backgroundColor: UIColor = .white
        /// 标题文字大小，默认 15
        let fontSize: CGFloat = 15
    }
}
