//
//  PJMessageViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/25.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let back = #selector(PJBreedsViewController.back)
}

class PJBreedsViewController: PJBaseViewController, UITableViewDelegate,
UITableViewDataSource {

    static let cellIdentifier = "PJBreedsViewControllerTableViewCell"
    
    var selectedModel: RealPetBreedModel?
    var sectionTitles = [String]()
    
    var tableViewModels = [RealPetBreedGroupModel]()
    var tableView: UITableView?
    var tableViewRefresh: UIRefreshControl?
    var sideSliderView: PJBreedsSideSliderView?
    
    var selectComplation: ((RealPetBreedModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "狗狗品种"
        backButtonTapped(backSel: .back)
        isHiddenBarBottomLineView = false
        view.backgroundColor = .white
        
        let sideSliderViewHeight = CGFloat(PJSCREEN_HEIGHT) - 35 - 35 - headerView!.bottom
        let siderSliderView_X = CGFloat(PJSCREEN_WIDTH) - 45
        let siderSliderView_Y = 35 + headerView!.bottom
        sideSliderView = PJBreedsSideSliderView(frame: CGRect(x: siderSliderView_X,
                                                              y: siderSliderView_Y,
                                                              width: 30,
                                                              height: sideSliderViewHeight))
        view.addSubview(sideSliderView!)
        sideSliderView?.selectedComplation = { [weak self] index in
            if let `self` = self {
                PJTapic.select()
                let indexPath = IndexPath(row: 0,
                                          section: index)
                self.tableView?.scrollToRow(at: indexPath,
                                            at: .top,
                                            animated: true)
            }
        }
        
        let tableView_width = view.width - sideSliderView!.width - 10 - 15
        let tableView_height = view.height - headerView!.height
        tableView = UITableView(frame: CGRect(x: 0, y: headerView!.bottom,
                                              width: tableView_width,
                                              height: tableView_height))
        view.addSubview(tableView!)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorStyle = .none
        tableView?.showsVerticalScrollIndicator = false
        
        RealPet.breedList(petType: "dog",
                          complationHandler: { [weak self] models in
                            if let `self` = self {
                                for model in models {
                                    self.sectionTitles.append(model.group!)
                                }
                                self.sideSliderView?.itemStrings = self.sectionTitles
                                self.tableViewModels = models
                                self.tableView?.reloadData()
                            }
            }, failedHandler: { (error) in
                
        })
        
    
        tableView?.register(UITableViewCell.self,
                            forCellReuseIdentifier: PJBreedsViewController.cellIdentifier)

    }
    
    // MAKR: - Actions
    @objc fileprivate func back() {
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewModels.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return tableViewModels[section].breeds?.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView(frame: CGRect(x: 0, y: 0,
                                               width: PJSCREEN_WIDTH,
                                               height: 35))
        sectionView.backgroundColor = .white

        let sectionLabel = UILabel(frame: CGRect(x: 15, y: 0,
                                               width: PJSCREEN_WIDTH - 15,
                                               height: 35))
        sectionLabel.text = tableViewModels[section].group ?? ""
        sectionLabel.font = UIFont.systemFont(ofSize: 14)
        sectionLabel.textColor = PJRGB(r: 102, g: 102, b: 102)
        sectionView.addSubview(sectionLabel)
        
        if section != 0 {
            let topLine = UIView(frame: CGRect(x: -15, y: 0,
                                               width: PJSCREEN_WIDTH + 15,
                                               height: 1))
            sectionView.addSubview(topLine)
            topLine.backgroundColor = .boderColor()
        }
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PJBreedsViewController.cellIdentifier, for: indexPath)
        let model = tableViewModels[indexPath.section].breeds?[indexPath.row]
        cell.textLabel?.text = model?.zh_name ?? ""
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.tintColor = .pinkColor()
        if (selectedModel != nil && selectedModel?.id == model?.id) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if selectComplation != nil {
            PJTapic.select()
            navigationController?.popViewController(animated: true)
            selectComplation!(tableViewModels[indexPath.section].breeds![indexPath.row])
        }
    }
    
    
}
