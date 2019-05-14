//
//  PJMessageViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/25.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let back = #selector(PJPetCreateBreedsViewController.back)
}

class PJPetCreateBreedsViewController: UIViewController, PJBaseViewControllerDelegate {
    static let cellIdentifier = "PJPetCreateBreedsTableViewCell"
    
    private var pop = PJBreedsPopView.newInstance()
    private var tableView: UITableView?
    private var tableViewRefresh: UIRefreshControl?
    private var timeStamp = 0

    
    var selectedModel: PJPet.PetBreedModel?
    var sectionTitles = [String]()
    var tableViewModels = [PJPet.PetBreedGroupModel]()
    var sideSliderView = PJBreedsSideSliderView()
    var selectComplation: ((PJPet.PetBreedModel) -> Void)?
    var petType = PJPet.PetType.dog {
        didSet {
            switch petType {
            case .cat:
                titleString = "选择猫咪品种"
            case .dog:
                titleString = "选择狗狗品种"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBaseView()
        backButtonTapped(backSel: .back, imageName: nil)
        rightBarButtonItem(imageName: "breeds_done", rightSel: .done)
        view.backgroundColor = .white
        
        let sideSiderViewWidth: CGFloat = 15
        let siderSliderView_X = view.pj_width - sideSiderViewWidth
        let siderSliderView_Y = 35 + navigationBarHeight
        sideSliderView = PJBreedsSideSliderView(frame: CGRect(x: siderSliderView_X, y: siderSliderView_Y, width: sideSiderViewWidth, height: 0))
        sideSliderView.isHidden = true
        sideSliderView.alpha = 0
        view.addSubview(sideSliderView)
        sideSliderView.selectedComplation = { [weak self] index in
            if let `self` = self {
                PJTapic.select()
                let indexPath = IndexPath(row: 0,
                                          section: index)
                self.tableView?.scrollToRow(at: indexPath,
                                            at: .top,
                                            animated: false)
                
                self.pop.y = self.sideSliderView.y + 5 + self.sideSliderView.buttonHeight * CGFloat(index)
                self.pop.setTitle(self.sideSliderView.itemStrings[index])
                self.pop.isHidden = false
                
                self.timeStamp = Int(Date().timeIntervalSince1970)
            }
        }
        
        let tableView_width = view.pj_width - sideSliderView.pj_width
        let tableView_height = view.pj_height - navigationBarHeight
        tableView = UITableView(frame: CGRect(x: 0, y: navigationBarHeight, width: tableView_width, height: tableView_height), style: .grouped)
        view.addSubview(tableView!)
        tableView?.backgroundColor = .white
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorStyle = .none
        tableView?.showsVerticalScrollIndicator = false
        
        PJPet.shared.breedList(petType: petType,
                               complationHandler: { [weak self] models in
                            if let `self` = self {
                                for model in models {
                                    self.sectionTitles.append(model.group)
                                }
                
                                self.sideSliderView.itemStrings = self.sectionTitles
                                self.sideSliderView.pj_height = CGFloat(self.sectionTitles.count * 25)
                                self.sideSliderView.centerY = self.view.centerY
                                self.sideSliderView.roundingCorners(corners: [.topLeft, .bottomLeft], radius: self.sideSliderView.pj_width / 2)
                                self.tableViewModels = models
                                self.tableView?.reloadData()
                            }
            }, failedHandler: {
                PJHUD.shared.showError(view: self.view, text: $0.errorMsg)
        })
    
        tableView?.register(UINib(nibName: "PJPetCreateBreedsTableViewCell", bundle: nil
        ), forCellReuseIdentifier: "PJPetCreateBreedsTableViewCell")
        
        
        pop.x = sideSliderView.left - 30
        pop.isHidden = true
        view.addSubview(pop)
        
        // 监听器
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            if Int(Date().timeIntervalSince1970) - self.timeStamp == 2 {
                self.pop.isHidden = true
                self.sideSliderView.isHidden = true
            }
        }
    }
}

private extension Selector {
    static let done = #selector(PJPetCreateBreedsViewController.done)
}

extension PJPetCreateBreedsViewController {
    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    fileprivate func done() {
        guard selectedModel != nil else {
            PJHUD.shared.showError(view: view, text: "还未选择品种哦")
            return
        }
        
        selectComplation?(selectedModel!)

        
        navigationController?.popViewController(animated: true)
    }
    
    func hiddenSideSliderView() {
        delay(by: 3) {
            UIView.animate(withDuration: 0.25, animations: {
                self.sideSliderView.alpha = 0
                self.pop.alpha = 0
            }) {
                if $0 {
                    self.sideSliderView.isHidden = true
                    self.pop.isHidden = true
                }
            }
        }
    }
}


extension PJPetCreateBreedsViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewModels.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return tableViewModels[section].breeds.count
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35
    }
}

extension PJPetCreateBreedsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView(frame: CGRect(x: 0, y: 0,
                                               width: PJSCREEN_WIDTH,
                                               height: 35))
        sectionView.backgroundColor = .white
        
        let sectionLabel = UILabel(frame: CGRect(x: 15, y: 0,
                                                 width: PJSCREEN_WIDTH - 15,
                                                 height: 35))
        sectionLabel.text = tableViewModels[section].group
        sectionLabel.font = UIFont.systemFont(ofSize: 14)
        sectionLabel.textColor = PJRGB(102, 102, 102)
        sectionView.addSubview(sectionLabel)
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        let sectionView = UIView(frame: CGRect(x: 0, y: 0,
                                               width: PJSCREEN_WIDTH,
                                               height: 35))
        sectionView.backgroundColor = .white
        
        let sectionLabel = UILabel(frame: CGRect(x: 15, y: 0,
                                                 width: PJSCREEN_WIDTH - 15,
                                                 height: 35))
        sectionLabel.text = "若没有您的犬种，请选择其它，并备注"
        sectionLabel.font = UIFont.systemFont(ofSize: 12)
        sectionLabel.textColor = PJRGB(155, 155, 155)
        sectionView.addSubview(sectionLabel)
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PJPetCreateBreedsViewController.cellIdentifier, for: indexPath) as! PJPetCreateBreedsTableViewCell
        let model = tableViewModels[indexPath.section].breeds[indexPath.row]
        cell.setTipsTitleText(model.zh_name)
        cell.selectionStyle = .none
        
        if (selectedModel != nil && selectedModel?.zh_name == model.zh_name) {
            cell.isHiddenTipImageView(false)
        } else {
            cell.isHiddenTipImageView(true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        PJTapic.select()
        
        let previousIndexPath = tableView.indexPathForSelectedRow
        if previousIndexPath != nil {
            let previousCell = tableView.cellForRow(at: previousIndexPath!) as? PJPetCreateBreedsTableViewCell
            if previousCell != nil {
                previousCell!.isHiddenTipImageView(true)
            }
        }
        
        let cell = tableView.cellForRow(at: indexPath) as! PJPetCreateBreedsTableViewCell
        if cell.tipsImageView.isHidden {
            cell.isHiddenTipImageView(false)
            selectedModel = tableViewModels[indexPath.section].breeds[indexPath.row]
        } else {
            cell.isHiddenTipImageView(true)
        }
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableViewModels[indexPath.section].breeds[indexPath.row].zh_name == "其它" {
            let vc = UIStoryboard(name: "PJPetCreateNameViewController", bundle: nil).instantiateViewController(withIdentifier: "PJPetCreateNameViewController") as! PJPetCreateNameViewController
            var breedString = "请输入狗狗品种"
            if petType == .cat {
                breedString = "请输入猫咪品种"
            }
            vc.viewModel = PJPetCreateNameViewController.ViewModel(title: "其它品种", placeholder: breedString, bottomString: "您填写的品种将会提交至后台审核，\n请耐心等待", doneString: "提交")
            
            selectComplation?(PJPet.PetBreedModel(id: -1, zh_name: "其它"))
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension PJPetCreateBreedsViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.sideSliderView.isHidden = false
        UIView.animate(withDuration: 0.25) {
            self.sideSliderView.alpha = 1
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating {
            scrollViewEndScrolling()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating {
            scrollViewEndScrolling()
        }
    }
    
    func scrollViewEndScrolling() {
        self.timeStamp = Int(Date().timeIntervalSince1970)
    }
}
