//
//  PJPlayCellView.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/6/11.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJPlayCellView: UIView {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    class func newInstance() -> PJPlayCellView {
        return Bundle.main.loadNibNamed("PJPlayCellView",
                                        owner: self,
                                        options: nil)?.first! as!PJPlayCellView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 14
        layer.masksToBounds = true
        
        let cellY = (pj_height - statusLabel.bottom - 28) / 2 + statusLabel.bottom
        let cellView = PJPlayCellDrawView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        
        let cellView2 = PJPlayCellDrawView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
//        addSubview(cellView2)
        
        let cellView3 = PJPlayCellDrawView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
//        addSubview(cellView3)
        
        let cellView4 = PJPlayCellDrawView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
//        addSubview(cellView4)
        
        let hStack = UIStackView(arrangedSubviews: [cellView, cellView2, cellView3, cellView4])
        hStack.frame = CGRect(x: 0, y: cellY, width: pj_width, height: 28)
        addSubview(hStack)
        hStack.axis = .horizontal
        hStack.distribution = .fillEqually
        
    }
}
