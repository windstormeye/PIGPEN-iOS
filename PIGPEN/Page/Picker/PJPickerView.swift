//
//  PJPickerView.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/11/11.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let ok = #selector(PJPickerView.okButtonTapped)
    static let dismissView = #selector(PJPickerView.dismissView)
}

class PJPickerView: UIViewController, UIPickerViewDelegate,
UIPickerViewDataSource {
    
    struct PickerModel {
        var pickerType: pickerType = .time
        var dataArray = [[String]]()
        var titleString = ""
    }
    
    enum pickerType {
        case time
        case custom
    }

    private var complationHandler: ((String) -> Void)?
    private var viewModel: PickerModel?
    private var backgroundView: UIView?
    private var topView: UIView?
    private var titleLabel: UILabel?
    private var okButton: UIButton?
    private var topViewBottomLine: UIView?
    private var pickerBackView: UIView?
    private var pickerWindow: UIWindow?
    private var mainWindow: UIWindow?
    private var picker: UIPickerView?
    private var datePicker: UIDatePicker?
    private var firstTitle = ""
    private var secondTitle = ""
    
    // MARK: - Life Cycle
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let safeInset = self.view.safeAreaInsets

        pickerBackView?.height += safeInset.bottom
        pickerBackView?.top -= safeInset.bottom
    }
    
    private func initView() {
        mainWindow = windowFromLevel(level: .normal)
        pickerWindow = windowFromLevel(level: .alert)
        
        if pickerWindow == nil {
            pickerWindow = UIWindow(frame: UIScreen.main.bounds)
            pickerWindow?.windowLevel = .alert
            pickerWindow?.backgroundColor = .clear
        }
        pickerWindow?.rootViewController = self
        pickerWindow?.isUserInteractionEnabled = true
        
        backgroundView = UIView(frame: view.frame)
        view.addSubview(backgroundView!)
        backgroundView?.alpha = 0
        backgroundView?.isUserInteractionEnabled = true
        backgroundView?.backgroundColor = .backgroundColor()
    
        let tap = UITapGestureRecognizer(target: self, action: .dismissView)
        backgroundView?.addGestureRecognizer(tap)
        
        pickerBackView = UIView(frame: CGRect(x: 0, y: view.height,
                                              width: view.width, height: 200))
        view.addSubview(pickerBackView!)
        pickerBackView?.backgroundColor = .white
        
        topView = UIView(frame: CGRect(x: 0, y: 0,
                                       width: view.width, height: 50))
        pickerBackView?.addSubview(topView!)
        topView?.backgroundColor = .white
        
        topViewBottomLine = UIView(frame: CGRect(x: 0,
                                                 y: topView!.bottom - 1,
                                                 width: view.width,
                                                 height: 1))
        topViewBottomLine?.backgroundColor = .boderColor()
        pickerBackView?.addSubview(topViewBottomLine!)
        
        switch viewModel!.pickerType {
        case .custom:
            picker = UIPickerView(frame: CGRect(x: 0, y: topView!.bottom,
                                                width: view.width,
                                                height: 150))
            picker?.backgroundColor = .white
            pickerBackView?.addSubview(picker!)
            picker?.delegate = self
            picker?.dataSource = self
        case .time:
            datePicker = UIDatePicker(frame: CGRect(x: 0, y: topView!.bottom,
                                                    width: view.width,
                                                    height: 150))
            datePicker?.datePickerMode = .date
            datePicker?.maximumDate = Date()
            datePicker?.minimumDate = Date(timeIntervalSince1970: 0)
            pickerBackView?.addSubview(datePicker!)
        }
        
        titleLabel = UILabel()
        topView?.addSubview(titleLabel!)
        titleLabel?.text = viewModel?.titleString
        titleLabel?.sizeToFit()
        titleLabel?.centerX = topView!.centerX
        titleLabel?.height = topView!.height

        okButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40,
                                              height: 30))
        topView?.addSubview(okButton!)
        okButton?.setTitle("完成", for: .normal)
        okButton?.setTitleColor(PJRGB(r: 0, g: 155, b: 250), for: .normal)
        okButton?.width = 40
        okButton?.right = view.width - 15
        okButton?.centerY = topView!.centerY
        okButton?.addTarget(self, action: .ok, for: .touchUpInside)
    }
    
    // MARK: - Public
    class func showPickerView(viewModel: ((_ model: inout PickerModel) -> Void)?,
                              complationHandler: @escaping (String) -> Void) {
        let picker = PJPickerView()
        picker.viewModel = PickerModel()
        if viewModel != nil {
            viewModel!(&picker.viewModel!)
            picker.initView()
        }
        
        picker.complationHandler = complationHandler
        picker.showPicker()
    }
    
    // MARK: - Actions
    @objc fileprivate func dismissView() {
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView?.alpha = 0
            self.pickerBackView?.top += 200
        }) { (finished) in
            if finished {
                UIView.animate(withDuration: 0.25, animations: {
                    self.pickerWindow?.isHidden = true
                    self.pickerWindow?.removeFromSuperview()
                    self.pickerWindow?.rootViewController = nil
                    self.pickerWindow = nil
                }, completion: { (finished) in
                    if finished {
                        self.mainWindow?.tintAdjustmentMode = .automatic
                        self.mainWindow?.tintColorDidChange()
                        self.mainWindow?.makeKeyAndVisible()
                    }
                })
            }
        }
    }
    
    private func showPicker() {
        pickerWindow?.addSubview(view)
        pickerWindow?.makeKeyAndVisible()
        
        mainWindow?.tintAdjustmentMode = .dimmed
        mainWindow?.tintColorDidChange()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView?.alpha = 1
            self.pickerBackView?.top -= 200
        })
    }
    
    @objc fileprivate func okButtonTapped() {
        var finalString = ""

        switch viewModel!.pickerType {
        case .custom:
            guard viewModel != nil else {
                return
            }
            if firstTitle != "" {
                finalString += firstTitle
            } else {
                firstTitle = viewModel!.dataArray[0][0]
                finalString += firstTitle
            }
            if secondTitle != "" {
                finalString += secondTitle
            } else {
                if viewModel!.dataArray.count > 1 {
                    secondTitle = viewModel!.dataArray[1][0]
                    finalString += secondTitle
                }
            }
        case .time:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            finalString = dateFormatter.string(from: datePicker!.date)
        }
        if complationHandler != nil {
            complationHandler!(finalString)
            dismissView()
        }
    }
    
    // MARK: - Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard viewModel != nil else {
            return 0
        }
        return viewModel!.dataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        guard viewModel != nil else {
            return 0
        }
        return viewModel!.dataArray[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        guard viewModel != nil else {
            return ""
        }
        return viewModel!.dataArray[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        guard viewModel != nil else {
            return
        }
        let string = viewModel!.dataArray[component][row]
        switch component {
        case 0: firstTitle = string
        case 1: secondTitle = string
        default: break
        }
    }
}
