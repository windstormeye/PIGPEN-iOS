//
//  PJSearchBar.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/14.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJSearchBar: UIView {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    class func newInstance() -> PJSearchBar? {
        let nibView = Bundle.main.loadNibNamed("PJSearchBar",
                                               owner: self,
                                               options: nil);
        if let view = nibView?.first as? PJSearchBar {
            return view
        }
        return nil
    }
}
