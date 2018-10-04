//
//  PJHUD.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/4.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

let hudWidth = 150.0
let hudHeight = 150.0

class PJHUD: PJBaseTipsView {
    static let shared = PJBaseTipsView()
    
    enum type {
        case normal
        case error
        case success
    }
    
    var hudType: type = .normal
    var hudText: String = ""
    
    private var tipsImageView: UIImageView?
    private var tipsTitleLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(_ hudType: type, hudText: String) {
        let rect = CGRect(x: (PJSCREEN_WIDTH - hudHeight)/2,
                          y: (PJSCREEN_HEIGHT - hudHeight)/2,
                          width: hudWidth, height: hudHeight)
        self.init(frame: rect)
        initView()
    }
    
    private func initView() {
        tipsImageView = UIImageView(frame: CGRect(x: 0, y: (height - 30)/2 - 10,
                                                  width: 30, height: 30))
        tipsImageView?.centerX = self.centerX
        tipsImageView?.image = UIImage(named: "close")
        addSubview(tipsImageView!)
        
        tipsTitleLabel = UILabel(frame: CGRect(x: 0,
                                               y: tipsImageView!.bottom + 5,
                                               width: width,
                                               height: height - tipsImageView!.bottom))
        tipsTitleLabel?.textAlignment = .center
        tipsTitleLabel?.text = hudText
        tipsTitleLabel?.textColor = .black
        tipsTitleLabel?.font = UIFont.systemFont(ofSize: 15)
        addSubview(tipsTitleLabel!)
    }
    
    class func show(hudType: type, hudText: String) {
        
    }

}
