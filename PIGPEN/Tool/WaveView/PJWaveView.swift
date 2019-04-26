//
//  PJWaveView.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/1/4.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJWaveView: UIView {
    // MARK: - Public Properties
    var viewModel: ViewModel? {
        didSet { initView() }
    }
    
    // MARK: - Public Methods
    
    
    // MARK: - Private Methods
    private func initView() {
        guard let viewModel = viewModel else { return }
        
        let waterHeight = viewModel.containerHeight / 10 * viewModel.level
        
        let backView = UIView(frame: CGRect(x: 0,
                                            y: self.pj_height - waterHeight,
                                            width: self.pj_width,
                                            height: waterHeight))
        addSubview(backView)
        backView.backgroundColor = viewModel.foregroundColor
        
        let waterView = YXWaveView(frame: CGRect(x: 0,
                                                 y: backView.top - 10,
                                                 width: self.pj_width,
                                                 height: 10))
        waterView.realWaveColor = viewModel.backgroundCOlor
        waterView.maskWaveColor = viewModel.foregroundColor
        waterView.waveSpeed = 1
        waterView.start()
        addSubview(waterView)
    }
}

extension PJWaveView {
    struct ViewModel {
        /// 分数
        var level: CGFloat
        /// 前景波浪颜色
        let foregroundColor: UIColor = .gradeForegroundColor
        /// 后景波浪颜色
        let backgroundCOlor: UIColor = .gradeBackgroundColor
        /// 波浪所占容器的高
        let containerHeight: CGFloat
    }
}
