//
//  PJCreateRealPetViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/12.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit
import Photos

fileprivate extension Selector {
    static let back = #selector(PJCreateRealPetViewController.back)
}

class PJCreateRealPetViewController: PJBaseViewController, UITextFieldDelegate {

    enum petType {
        case cat
        case dog
    }
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    // tag = 1000
    @IBOutlet weak var breedTextField: UITextField!
    // tag = 1001
    @IBOutlet weak var birthTextField: UITextField!
    // tag = 1002
    @IBOutlet weak var weightTextField: UITextField!
    // tag = 1003
    @IBOutlet weak var pppTextField: UITextField!
    // tag = 1004
    @IBOutlet weak var loveTextField: UITextField!
    // tag = 1005
    @IBOutlet weak var relationshipTextField: UITextField!
    // tag = 1006
    @IBOutlet weak var dogEatTextField: UITextField!
    @IBOutlet weak var dogEatLineView: UIView!
    @IBOutlet weak var loveStatusConstraint: NSLayoutConstraint!
    
    var tempBreedModel: PJRealPet.RealPetBreedModel?
    // defual = cat, false == cat
    var catOrDog: petType = .cat
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        navigationItem.title = "添加宠物资料"
        backButtonTapped(backSel: .back)
        isHiddenBarBottomLineView = false
        
        okButton.backgroundColor = UIColor.unFocusColor()
        
        breedTextField.delegate = self
        pppTextField.delegate = self
        breedTextField.delegate = self
        birthTextField.delegate = self
        relationshipTextField.delegate = self
        weightTextField.delegate = self
        loveTextField.delegate = self
        dogEatTextField.delegate = self
        
        // 该段代码不能放入 `viewWillLayoutSubviews`，PJAlertView dismiss 后会再调用一次
        switch catOrDog {
        case .dog:
            loveStatusConstraint.constant += 50
        case .cat:
            dogEatTextField.isHidden = true
            dogEatLineView.isHidden = true
        }
    }
    
    // MARK: Action
    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func femaleButtonTapped(_ sender: UIButton) {
        femaleButton.isSelected = !femaleButton.isSelected
        maleButton.isSelected = false
    }
    
    @IBAction func maleButtonTapped(_ sender: UIButton) {
        maleButton.isSelected = !maleButton.isSelected
        femaleButton.isSelected = false
    }
    
    @IBAction func okButtonTapped(_ sender: UIButton) {
        // TODO: 在这里进行测试七牛图片上传
    }
    
    @IBAction func avatarTapped(_ sender: UITapGestureRecognizer) {
//        let album = PJAlbumDataManager.manager().albums.filter({ (collection) -> Bool in
//            return collection.assetCollectionSubtype == .smartAlbumUserLibrary
//        })
//        if album.count == 0 { return }
//
//        let vc = PJAlbumDetailsViewController()
//        vc.currentAlbumCollection = album[0]
//        PJAlbumDataManager.manager().getAlbumPhotos(albumCollection: album[0], complateHandler: { photos, assets  in
//            vc.models = photos
//            vc.currentAlbumAssets = assets
//            self.navigationController?.pushViewController(vc, animated: true)
//        })
//        vc.selectedComplateHandler = { [weak self] photo in
//            guard let `self` = self else { return }
//            self.avatarImageView.image = photo.photoImage
//        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        let actionsSheet = UIAlertController(title: "选择宠物头像来源", message: nil, preferredStyle: .actionSheet)
        let albumAction = UIAlertAction(title: "从相册选择", style: .default) { (action) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cameraAction = UIAlertAction(title: "从相机拍摄", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let cancleAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        actionsSheet.addAction(albumAction)
        actionsSheet.addAction(cameraAction)
        actionsSheet.addAction(cancleAction)
        
        present(actionsSheet, animated: true, completion: nil)
    }
    
    // MARK: - Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard textField.tag >= 1000 else {
            return true
        }
        
        switch textField.tag {
        case 1000:
            let vc = PJBreedsViewController()
            vc.selectComplation = { [weak self] model in
                if let `self` = self {
                    self.breedTextField.text = model.zh_name ?? ""
                    self.tempBreedModel = model
                }
            }
            if tempBreedModel != nil {
                vc.selectedModel = tempBreedModel
            }
            navigationController?.pushViewController(vc,
                                                     animated: true)
        case 1001:
            let _ = PJPickerView.showPickerView(viewModel: { (viewModel) in
                viewModel.titleString = "猫咪的生日"
                viewModel.pickerType = .time
            }) { [weak self] finalString in
                if let `self` = self {
                    self.birthTextField.text = finalString
                }
            }
        case 1002:
            let _ = PJPickerView.showPickerView(viewModel: { (viewModel) in
                viewModel.titleString = "猫咪体重"
                var weightArray = [String]()
                for item in 0...100 {
                    weightArray.append("\(item)")
                }
                var o_weightArray = [String]()
                for item in 0..<10 {
                    o_weightArray.append("\(item)")
                }
                viewModel.dataArray = [weightArray, o_weightArray, ["kg"]]
                viewModel.pickerType = .custom
            }) { [weak self] finalString in
                if let `self` = self {
                    guard finalString != "00" else {
                        return
                    }
                    var finalString = finalString
                    if (finalString[finalString.startIndex] == "0") {
                        finalString.remove(at: finalString.startIndex)
                    }
                    self.weightTextField.text = finalString + "00g"
                }
            }
        case 1003:
            let _ = PJPickerView.showPickerView(viewModel: { (viewModel) in
                viewModel.titleString = "绝育情况"
                viewModel.pickerType = .custom
                viewModel.dataArray = [["已绝育", "未绝育"]]
            }) { [weak self] finalString in
                if let `self` = self {
                    self.pppTextField.text = finalString
                }
            }
        case 1004:
            let _ = PJPickerView.showPickerView(viewModel: { (viewModel) in
                viewModel.titleString = "感情状态"
                viewModel.pickerType = .custom
                viewModel.dataArray = [["单身", "约会中", "已婚"]]
            }) { [weak self] finalString in
                if let `self` = self {
                    self.loveTextField.text = finalString
                }
            }
        case 1005:
            let _ = PJPickerView.showPickerView(viewModel: { (viewModel) in
                viewModel.titleString = "猫咪与您的关系"
                viewModel.pickerType = .custom
                viewModel.dataArray = [["我是妈咪", "我是爸比", "我是爷爷", "我是奶奶",
                                        "我是姐姐", "我是哥哥", "我是弟弟", "我是妹妹",
                                        "我是干爸", "我是干妈", "我是叔叔", "我是阿姨",]]
            }) { [weak self] finalString in
                if let `self` = self {
                    self.relationshipTextField.text = finalString
                }
            }
        case 1006:
            let picker = PJPickerView.showPickerView(viewModel: { (viewModel) in
                var items = [String]()
                for item in 1...1000 {
                    items.append("\(item)")
                }
                viewModel.titleString = "每日进食量"
                viewModel.pickerType = .custom
                viewModel.leftButtonName = "每日进食量参考值"
                viewModel.dataArray = [items, ["g"]]
            }) { [weak self] finalString in
                if let `self` = self {
                    self.dogEatTextField.text = finalString
                }
            }
            picker!.leftButtonTappedHandler = { [weak self] in
                guard let `self` = self else {return}
                self.navigationController?.pushViewController(PJDogFoodViewController(),
                                                              animated: true)
            }
        default: break
        }
        
        return false
    }
}

// MARK: - UIImagePicker
extension PJCreateRealPetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker .dismiss(animated: true, completion: nil)
        let phasset = info[.phAsset] as! PHAsset
        PJAlbumDataManager.manager().convertPHAssetToUIImage(asset: phasset,
                                                             size: CGSize(width: 150, height: 150),
                                                             mode: .highQualityFormat,
                                                             complateHandler: { [weak self] photoImage in
                                                                guard let `self` = self else { return }
                                                                self.avatarImageView.image = photoImage
        })
        
        PJImageUploader.upload(assets: [phasset], complateHandler: {
            
        }) { (error) in
            print(error.errorMsg)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
