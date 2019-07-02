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
    
    private var sheetView = UIView()
    private var backgroundView = UIView()
    private var complateHandler: ((Int) -> Void)?
    
    // MARK: - Public
    class func showAlertSheet(viewModel: ((_ model: inout ViewModel) -> Void)?,
                              complationHandler: @escaping (Int) -> Void) {
        let alertSheet = PJAlertSheet()
        
        if viewModel != nil {
            viewModel!(&alertSheet.viewModel)
            alertSheet.initView()
        }
        
        alertSheet.complateHandler = complationHandler
        alertSheet.showSheet()
    }
    
    // MARK: - Life Cycle
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let safeInset = self.view.safeAreaInsets
        
//        pickerBackView?.pj_height += safeInset.bottom
//        pickerBackView?.top -= safeInset.bottom
    }
    
    private func initView() {
        backgroundView = UIView(frame: view.frame)
        view.addSubview(backgroundView)
        backgroundView.alpha = 0
        backgroundView.isUserInteractionEnabled = true
        backgroundView.backgroundColor = PJRGB(220, 220, 220)
        
        let tap = UITapGestureRecognizer(target: self, action: .dismissView)
        backgroundView.addGestureRecognizer(tap)
        
        
        sheetView.frame = CGRect(x: 10, y: view.pj_height, width: PJSCREEN_WIDTH - 20, height: 170 + bottomSafeAreaHeight)
        sheetView.roundingCorners(corners: [.topLeft, .topRight], radius: 20)
        view.addSubview(sheetView)
        sheetView.backgroundColor = .white
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: sheetView.pj_width, height: sheetView.pj_height / 2))
        sheetView.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.text = viewModel.title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        var bottomViewModel = PJBottomSelectedButtonView.ViewModel()
        bottomViewModel.firstValue = viewModel.firstButtonValue
        bottomViewModel.secondValue = viewModel.secondButtonValue
        
        let bottomButtonView = PJBottomSelectedButtonView(frame: CGRect(x: 0, y: sheetView.pj_height - 70 - bottomSafeAreaHeight, width: sheetView.pj_width, height: 40), viewModel: bottomViewModel)
        sheetView.addSubview(bottomButtonView)
        bottomButtonView.firstSelected = {
            self.complateHandler?(0)
            self.dismissView()
        }
        bottomButtonView.secondSelected = {
            self.complateHandler?(1)
            self.dismissView()
        }
    }
    
    private func showSheet() {
        showAlert()
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.backgroundView.alpha = 0.7
            self.sheetView.bottom = self.view.pj_height
        }, completion: nil)
    }
}

extension PJAlertSheet {
    struct ViewModel {
        var title: String
        var firstButtonValue: String
        var secondButtonValue: String
        
        init() {
            title = ""
            firstButtonValue = ""
            secondButtonValue = ""
        }
    }
}

extension PJAlertSheet {
    @objc
    fileprivate func dismissView() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.backgroundView.alpha = 0
            self.sheetView.top = self.view.pj_height
        }) { (finished) in
            if finished {
                self.dismissAlert()
            }
        }
    }
}

fileprivate extension Selector {
    static let dismissView = #selector(PJAlertSheet.dismissView)
}
