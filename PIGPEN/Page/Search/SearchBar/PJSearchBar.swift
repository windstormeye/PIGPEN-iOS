//
//  PJSearchBar.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/14.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJSearchBar: UIView {
    var returnKeyDown: ((String) -> Void)?
    
    @IBOutlet weak private var searchTextField: UITextField!
    @IBOutlet weak private var searchButton: UIButton!
    
    class func newInstance() -> PJSearchBar? {
        let nibView = Bundle.main.loadNibNamed("PJSearchBar",
                                               owner: self,
                                               options: nil);
        if let view = nibView?.first as? PJSearchBar {
            return view
        }
        return nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchTextField.delegate = self
    }
}

extension PJSearchBar: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        returnKeyDown?(textField.text ?? "")
        return true
    }
}
