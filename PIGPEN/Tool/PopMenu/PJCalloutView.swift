//
//  PJPopMenuView.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/1/9.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let close = #selector(PJCalloutView.close(button:))
}

class PJCalloutView: UIView {
    var viewModel: PJCalloutViewModel {
        didSet {
            didSetViewModel()
        }
    }
    private var complationBlock: ((_ buttonIndex: Int) -> Void)?
    
    
    // MAKR: - Life cycle
    override init(frame: CGRect) {
        let f_frame = CGRect(x: frame.origin.x, y: frame.origin.y,
                             width: frame.size.width,
                             height: frame.size.height + 14)
        viewModel = PJCalloutViewModel()
        super.init(frame: f_frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = PJCalloutViewModel()
        super.init(coder: aDecoder)
    }
    
    convenience init(frame: CGRect,
                     _ modelBlock: @escaping (_ model: inout PJCalloutViewModel) -> Void,
                     complationBlock: @escaping (_ buttonIndex: Int) -> Void) {
        let newFrame = CGRect(x: frame.origin.x, y: frame.origin.y,
                              width: frame.size.width,
                              height: frame.size.height + 14)
        self.init(frame: newFrame)
        
        modelBlock(&viewModel)
        self.complationBlock = complationBlock
        
        initView()
    }
    
    private func initView() {
        self.isUserInteractionEnabled = true
        self.backgroundColor = .clear
        
        var index = 0
        for buttonName in viewModel.buttonNames {
            let height = viewModel.buttonHeight
            let button = UIButton(frame: CGRect(x: 0, y: 8 + (index * height),
                                                width: Int(self.pj_width),
                                                height: height))
            self.addSubview(button)
            button.setTitle(buttonName, for: .normal)
            button.backgroundColor = UIColor.darkGray
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.addTarget(self, action: .close, for: .touchUpInside)
            
            switch viewModel.buttonType {
            case .text: break
            case .left_icon:
                button.setImage(UIImage(named: viewModel.iconNames[index]),
                                for: .normal)
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0,
                                                      bottom: 0, right: 5)
                button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10,
                                                      bottom: 0, right: 0)
            case .right_icon: break
            }
            
            button.tag = index
            self.pj_height = button.bottom
            index += 1
        }
    }
    
    override func draw(_ rect: CGRect) {
        let width = self.bounds.size.width
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(2)
        context?.setFillColor(viewModel.backgroundColor.cgColor)
        var points = Array<CGPoint>()
        switch viewModel.arrowType {
        case .top_right:
            points.append(CGPoint(x: width - 13, y: 0))
            points.append(CGPoint(x: width - 6, y: 8))
            points.append(CGPoint(x: width - 20, y: 8))
        case .top_left:
            points.append(CGPoint(x: 13, y: 0))
            points.append(CGPoint(x: 6, y: 8))
            points.append(CGPoint(x: 20, y: 8))
        case .down_right: break
        case .down_letf: break
        }
        
        context?.move(to: points[0])
        //从起始点到这一点
        context?.addLine(to: points[1])
        // 最后一点
        context?.addLine(to: points[2])
        //闭合路径
        context?.closePath()
        context?.fillPath()
    }
    
    // MARK: - Actions
    @objc fileprivate func close(button: UIButton) {
        self.removeFromSuperview()
        if self.complationBlock != nil {
            self.complationBlock!(button.tag)
        }
    }
    
    // MARK: - setter & getter
    private func didSetViewModel() {
        setNeedsDisplay()
    }
}

extension PJCalloutView {
    struct PJCalloutViewModel {
        var buttonNames = [""]
        var iconNames = [""]
        var arrowType: arrowType = .top_right
        var buttonType: buttonType = .text
        var backgroundColor = UIColor.darkGray
        var buttonHeight = 35
    }
    
    enum arrowType {
        case top_right
        case top_left
        case down_right
        case down_letf
    }
    
    enum buttonType {
        case text
        case left_icon
        case right_icon
    }
}
