//
//  PJDogPlayEditTableViewCell.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/23.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJDogPlayEditTableViewCell: UITableViewCell {
    /// 删除
    var deleteSeleted: (() -> Void)?
    /// 侧滑
    var swiping: (() -> Void)?
    
    @IBOutlet private weak var secondValueLabel: UILabel!
    @IBOutlet private weak var secondTextLabel: UILabel!
    @IBOutlet private weak var firstValueLabel: UILabel!
    @IBOutlet private weak var firstTextLabel: UILabel!
    @IBOutlet private weak var bgImageView: UIImageView!
    @IBOutlet weak var contentStackView: UIStackView!
    
    private var topLine = UIView()
    private var redDotImageView = UIImageView()
    private var bottomLine = UIView()
    private var b = UIButton()
    
    /// bgImageView 原始 X
    private var originBgImageViewX: CGFloat = 0.0
    /// stackView 原始 X
    private var originStackViewX: CGFloat = 0.0
    /// 判断当前滑动方向
    private var swipeOritationX: CGFloat = 0.0
    /// 滑动的距离
    private var swipeDistance: CGFloat = 0.0
    
    var viewModel = ViewModel() {
        didSet {
            initView()
        }
    }
    
    var cellType: PJDogPlayEditTableView.TableViewType = .play {
        didSet {
            switch cellType {
            case .play:
                firstTextLabel.text = "遛狗时间"
                secondTextLabel.text = "消耗热量"
            case .drink:
                firstTextLabel.text = "喝水时间"
                secondTextLabel.text = "喝水毫升"
            case .eat:
                firstTextLabel.text = "喂食时间"
                secondTextLabel.text = "喂食克数"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        topLine = UIView(frame: CGRect(x: 48, y: 0, width: 1, height: 58 / 2 - 4))
        contentView.addSubview(topLine)
        topLine.backgroundColor = PJRGB(240, 240, 240)
        contentView.sendSubviewToBack(topLine)
        
        redDotImageView = UIImageView(frame: CGRect(x: 46.5, y: topLine.bottom + 2, width: 4, height: 4))
        contentView.addSubview(redDotImageView)
        redDotImageView.image = UIImage(named: "pet_play_edit_side_redDot")
        contentView.sendSubviewToBack(redDotImageView)
        
        bottomLine = UIView(frame: CGRect(x: 48, y: redDotImageView.bottom + 2, width: 1, height: pj_height - redDotImageView.bottom - 2))
        contentView.addSubview(bottomLine)
        bottomLine.backgroundColor = PJRGB(240, 240, 240)
        contentView.sendSubviewToBack(bottomLine)
        
        b = UIButton(frame: CGRect(x: 0, y: (pj_height - 50) / 2, width: 60, height: 50))
        contentView.addSubview(b)
        b.setImage(UIImage(named: "trash"), for: .normal)
        b.right = PJSCREEN_WIDTH - 20
        b.addTarget(self, action: .delete, for: .touchUpInside)
        contentView.sendSubviewToBack(b)
        
        let swipe = UIPanGestureRecognizer(target: self, action: .leftSwipe)
        addGestureRecognizer(swipe)
        
        originBgImageViewX = bgImageView.left
        originStackViewX = contentStackView.left
    }
    
    private func initView() {
        firstValueLabel.text = viewModel.firstValue
        secondValueLabel.text = viewModel.secondValue
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        
    }
    
    /// 更新 cell 背景图片
    func updateBackgroundImage(_ imageName: String) {
        bgImageView.image = UIImage(named: imageName)
    }
    
    /// 先执行恢复 UI，再发送删除闭包
    private func recoveryUI() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.bgImageView.left = self.originBgImageViewX
            self.contentStackView.left = self.originStackViewX
        }) {
            if $0 {
                self.deleteSeleted?()
            }
        }
        
        swipeOritationX = 0
        swipeDistance = 0
    }
}

extension PJDogPlayEditTableViewCell {
    @objc
    fileprivate func deleteAction() {
        recoveryUI()
    }
    
    @objc
    fileprivate func leftSwipe(pan: UIPanGestureRecognizer) {
        let point = pan.location(in: self)
        /// 当前滑动方向
        var isLeft = true
        /// 判断当前滑动方向
        
        if pan.state == .began {
            if bgImageView.right == b.left {
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    self.bgImageView.left = self.originBgImageViewX
                    self.contentStackView.left = self.originStackViewX
                }, completion: nil)
                
                swipeOritationX = 0
                swipeDistance = 0
                
                return
            }
            
            swipeOritationX = point.x
        }
        
        if pan.state == .changed {
            if swipeOritationX < point.x {
                isLeft = false
            } else {
                isLeft = true
            }
        }
        
        /// 计算需要偏移的距离
        var moveX = 0
        if swipeDistance == 0 {
            swipeDistance = point.x
        } else {
            moveX = Int(abs(point.x - swipeDistance))
        }
        
        /// 左滑
        if isLeft {
            bgImageView.left = originBgImageViewX - CGFloat(moveX)
            contentStackView.left = originStackViewX - CGFloat(moveX)
            
            /// 超过了「垃圾桶」按钮的左边
            if bgImageView.right <= b.left {
                bgImageView.right = b.left
                contentStackView.right = b.left + 10
            }
            
            if pan.state == .ended {
                if bgImageView.left <= originBgImageViewX - 20 {
                    UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                        self.bgImageView.right = self.b.left
                        self.contentStackView.right = self.bgImageView.right + 10
                    }, completion: nil)
                } else {
                    UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                        self.bgImageView.left = self.originBgImageViewX
                        self.contentStackView.left = self.originStackViewX
                    }, completion: nil)
                }
                
                swipeOritationX = 0
                swipeDistance = 0
            }
        /// 右滑
        } else {
            if pan.state == .ended {
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    self.bgImageView.left = self.originBgImageViewX
                    self.contentStackView.left = self.originStackViewX
                }, completion: nil)
            }
            
            swipeOritationX = 0
            swipeDistance = 0
        }
    }
}

private extension Selector {
    static let leftSwipe = #selector(PJDogPlayEditTableViewCell.leftSwipe(pan:))
    static let delete = #selector(PJDogPlayEditTableViewCell.deleteAction)
}

extension PJDogPlayEditTableViewCell {
    struct ViewModel {
        var firstValue: String
        var secondValue: String
        
        init() {
            firstValue = ""
            secondValue = ""
        }
    }
}
