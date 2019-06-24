//
//  PJPetAboutScoreView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/24.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJPetAboutScoreView: UIView {

    var viewModel = ViewModel() {
        didSet {
            initView()
        }
    }
    
    @IBOutlet private weak var dogImageView: UIImageView!
    @IBOutlet private weak var firstValue: UILabel!
    @IBOutlet private weak var firstTextLabel: UILabel!
    @IBOutlet private weak var secondValue: UILabel!
    @IBOutlet private weak var secondTextLabel: UILabel!
    @IBOutlet private weak var thirdValue: UILabel!
    @IBOutlet private weak var thirdTextLabel: UILabel!
    
    class func newInstance() -> PJPetAboutScoreView {
        return Bundle.main.loadNibNamed("PJPetAboutScoreView", owner: self, options: nil)?.first as! PJPetAboutScoreView
    }
    
    private func initView() {
//        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width - 40, 1)];
//        [self.view addSubview:line];
//        //绘制虚线
//        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//        [shapeLayer setBounds:line.bounds];
//        [shapeLayer setPosition:CGPointMake(line.frame.size.width / 2.0,line.frame.size.height)];
//        [shapeLayer setFillColor:[UIColor clearColor].CGColor];
//        //设置虚线颜色
//        [shapeLayer setStrokeColor:[UIColor blackColor].CGColor];
//        //设置虚线宽度
//        [shapeLayer setLineWidth:0.5];
//        [shapeLayer setLineJoin:kCALineJoinRound];
//        //设置虚线的线宽及间距
//        [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:5], [NSNumber numberWithInt:2], nil]];
//        //创建虚线绘制路径
//        CGMutablePathRef path = CGPathCreateMutable();
//        //设置虚线绘制路径起点
//        CGPathMoveToPoint(path, NULL, 0, 0);
//        //设置虚线绘制路径终点
//        CGPathAddLineToPoint(path, NULL, line.frame.size.width, 0);
//        //设置虚线绘制路径
//        [shapeLayer setPath:path];
//        CGPathRelease(path);
//        //添加虚线
//        [line.layer addSublayer:shapeLayer];
        
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.bounds = CGRect(x: 0, y: dogImageView.bottom + 5, width: pj_width - 40, height: 5)
//        shapeLayer.position = CGPoint(x: 0, y: dogImageView.bottom + 7)
//        shapeLayer.fillColor = UIColor.red.cgColor
//        //设置虚线颜色
//        shapeLayer.strokeColor = UIColor.black.cgColor
//        //设置虚线宽度
//        shapeLayer.lineWidth = 4
//        shapeLayer.lineJoin = .round
//        shapeLayer.lineCap = .round
//        //设置虚线的线宽及间距
//        shapeLayer.lineDashPattern = [1, 10]
//        //创建虚线绘制路径
//        let path = CGMutablePath()
//        //设置虚线绘制路径起点
//        path.move(to: CGPoint(x: 100, y: dogImageView.bottom + 10), transform: .identity)
//        //设置虚线绘制路径终点
//        path.addLine(to: CGPoint(x: pj_width, y: dogImageView.bottom + 10), transform: .identity)
//        //设置虚线绘制路径
//        shapeLayer.path = path
//        //添加虚线
//        layer.addSublayer(shapeLayer)
        
        let backLineView = UIView(frame: CGRect(x: 20, y: dogImageView.bottom + 7, width: pj_width - 40, height: 3))
        addSubview(backLineView)
        
        let backLineShapeLayer = CAShapeLayer()
        backLineShapeLayer.bounds = backLineView.bounds
        backLineShapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        backLineShapeLayer.strokeColor = UIColor.white.cgColor
        
        backLineShapeLayer.lineWidth = backLineView.pj_height
        backLineShapeLayer.lineJoin = .round
        backLineShapeLayer.lineCap = .round
        
        backLineShapeLayer.lineDashPattern = [2, 7]
        
        let bakLinePath = CGMutablePath()
        bakLinePath.move(to: CGPoint(x: 40, y: dogImageView.bottom + 7))
        bakLinePath.addLine(to: CGPoint(x: backLineView.pj_width, y: dogImageView.bottom + 7))
    
        backLineShapeLayer.path = bakLinePath
        layer.addSublayer(backLineShapeLayer)
        
        let foreLineView = UIView(frame: CGRect(x: 20, y: dogImageView.bottom + 7, width: pj_width - 40, height: 3))
        addSubview(foreLineView)
        
        let foreShapeLayer = CAShapeLayer()
        foreShapeLayer.bounds = foreLineView.bounds
        foreShapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        foreShapeLayer.strokeColor = PJRGB(255, 85, 67).cgColor
        
        foreShapeLayer.lineWidth = backLineView.frame.size.height
        foreShapeLayer.lineJoin = .round
        foreShapeLayer.lineCap = .round
        
        foreShapeLayer.lineDashPattern = [2, 7]
        
        let forePath = CGMutablePath()
        forePath.move(to: CGPoint(x: 40, y: dogImageView.bottom + 7))
        forePath.addLine(to: CGPoint(x: foreLineView.pj_width - 90, y: dogImageView.bottom + 7))
        
        foreShapeLayer.path = forePath
        layer.addSublayer(foreShapeLayer)
    }
}

extension PJPetAboutScoreView {
    struct ViewModel {
        var score: CGFloat
        var firstValue: String
        var secondValue: String
        var thirdValue: String
        
        init() {
            score = 0
            firstValue = "-"
            secondValue = "-"
            thirdValue = "-"
        }
    }
}
