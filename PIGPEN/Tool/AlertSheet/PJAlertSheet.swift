//
//  PJAlertSheet.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/29.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJAlertSheet: PJBaseAlertViewController {
    
    var viewModel = ViewModel()
    
    // MARK: - Public
    class func showAlertSheet(viewModel: ((_ model: inout ViewModel) -> Void)?,
                              complationHandler: @escaping (String, ViewModel) -> Void) -> PJAlertSheet? {
        let alertSheet = PJAlertSheet()
        if viewModel != nil {
            viewModel!(&alertSheet.viewModel)
            alertSheet.initView()
        }
//
//        picker.complationHandler = complationHandler
//        picker.showPicker()
//
        return alertSheet
    }
    
    // MARK: - Life Cycle
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let safeInset = self.view.safeAreaInsets
        
//        pickerBackView?.pj_height += safeInset.bottom
//        pickerBackView?.top -= safeInset.bottom
    }
    
    private func initView() {
    }
}

extension PJAlertSheet {
    struct ViewModel {
        var title: String
        var firstValue: String
        var secondValue: String
        
        init() {
            title = ""
            firstValue = ""
            secondValue = ""
        }
    }
}
