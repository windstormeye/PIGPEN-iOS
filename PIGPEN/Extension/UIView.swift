//
//  UIViewPosition.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/25.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

extension UIView {
    /// 自定义圆角
    public func roundingCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let pathMaskLayer = CAShapeLayer()
        pathMaskLayer.frame = bounds
        pathMaskLayer.path = path.cgPath
        layer.mask = pathMaskLayer
    }
}

extension UIView {
    static private let PJSCREEN_SCALE = UIScreen.main.scale
    
    private func getPixintegral(pointValue: CGFloat) -> CGFloat {
        return round(pointValue * UIView.PJSCREEN_SCALE) / UIView.PJSCREEN_SCALE
    }
    
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(x) {
            self.frame = CGRect.init(
                x: getPixintegral(pointValue: x),
                y: self.y,
                width: self.pj_width,
                height: self.pj_height
            )
        }
    }
    
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(y) {
            self.frame = CGRect.init(
                x: self.x,
                y: getPixintegral(pointValue: y),
                width: self.pj_width,
                height: self.pj_height
            )
        }
    }
    
    public var pj_width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(width) {
            self.frame = CGRect.init(
                x: self.x,
                y: self.y,
                width: getPixintegral(pointValue: width),
                height: self.pj_height
            )
        }
    }
    
    public var pj_height: CGFloat {
        get {
            return self.frame.size.height
        }
        set (height) {
            self.frame = CGRect.init(
                x: self.x,
                y: self.y,
                width: self.pj_width,
                height: getPixintegral(pointValue: height)
            )
        }
    }
    
    public var bottom: CGFloat {
        get {
            return self.y + self.pj_height
        }
        set(bottom) {
            self.y = bottom - self.pj_height
        }
    }
    
    public var right: CGFloat {
        get {
            return self.x + self.pj_width
        }
        set (right) {
            self.x = right - self.pj_width
        }
    }
    
    public var left: CGFloat {
        get {
            return self.x
        }
        set(left) {
            self.x = left
        }
    }
    
    public var top: CGFloat {
        get {
            return self.y
        }
        set(top) {
            self.y = top
        }
    }
    
    public var centerX: CGFloat {
        get {
            return self.center.x
        }
        set(centerX) {
            self.center = CGPoint.init(
                x: getPixintegral(pointValue: centerX),
                y: self.center.y
            )
        }
    }
    
    public var centerY: CGFloat {
        get {
            return self.center.y
        }
        set (centerY) {
            self.center = CGPoint.init(x: self.center.x, y: getPixintegral(pointValue: centerY))
        }
    }
    
}
