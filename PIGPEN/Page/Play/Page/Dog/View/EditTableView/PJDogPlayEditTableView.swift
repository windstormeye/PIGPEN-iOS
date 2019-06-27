//
//  PJDogPlayEditTableView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/23.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJDogPlayEditTableView: UITableView {
    /// 判断是否为今天
    private var cellCurrentDay = 0
    private var sectionCurrentDay = 0
    
    var viewModels = [PJDogPlayEditTableView.ViewModel]() {
        didSet { reloadData() }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        backgroundColor = .clear
        delegate = self
        dataSource = self
        
        separatorStyle = .none
        
        register(UINib(nibName: "PJDogPlayEditTableViewCell", bundle: nil), forCellReuseIdentifier: "PJDogPlayEditTableViewCell")
        register(UINib(nibName: "PJDogPlayEditOldTableViewCell", bundle: nil), forCellReuseIdentifier: "PJDogPlayEditOldTableViewCell")
    }
}

extension PJDogPlayEditTableView {
    func convertData(datas: [PJPet.DogPlayHistory]) {
        var viewModels = [PJDogPlayEditTableView.ViewModel]()
        
        for data in datas {
            var viewModel = PJDogPlayEditTableView.ViewModel()
            viewModel.sectionTitle = "\(data.date)"
            for d in data.plays {
                var vm = PJDogPlayEditTableViewCell.ViewModel()
                vm.firstValue = convertTimestampToDateString0(d.durations)
                vm.secondValue = "\(d.kcals)kcal"
                
                viewModel.sectionCells.append(vm)
            }
            viewModels.append(viewModel)
        }
        
        self.viewModels = viewModels
    }
}

extension PJDogPlayEditTableView: UITableViewDelegate {
}

extension PJDogPlayEditTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellCurrentDay == 0 {
            cellCurrentDay = convertTimestampToDateInt(Int(viewModels[indexPath.section].sectionTitle)!)
            return 58
        } else {
            let tempDay = convertTimestampToDateInt(Int(viewModels[indexPath.section].sectionTitle)!)
            switch cellCurrentDay - tempDay {
            case 0:
                return 58
            case 1:
                return 58
            case 2:
                return 58
            default:
                return 43
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: pj_width, height: pj_height))
        
        let sectionLabel = UILabel(frame: CGRect(x: 15, y: 0, width: pj_width - 15, height: 15))
        sectionLabel.text = convertTimestampToDateString1(Int(viewModels[section].sectionTitle)!)
        sectionLabel.font = UIFont.systemFont(ofSize: 14)
        sectionLabel.textColor = .black
        sectionLabel.backgroundColor = .white
        
        sectionView.addSubview(sectionLabel)
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels[section].sectionCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cellCurrentDay == 0 {
            cellCurrentDay = convertTimestampToDateInt(Int(viewModels[indexPath.section].sectionTitle)!)
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PJDogPlayEditTableViewCell",
                                                     for: indexPath) as! PJDogPlayEditTableViewCell
            cell.updateBackgroundImage("pet_play_edit_side_cell0")
            cell.viewModel = viewModels[indexPath.section].sectionCells[indexPath.row]
            return cell
        } else {
            let tempDay = convertTimestampToDateInt(Int(viewModels[indexPath.section].sectionTitle)!)
            switch cellCurrentDay - tempDay {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PJDogPlayEditTableViewCell",
                                                         for: indexPath) as! PJDogPlayEditTableViewCell
                cell.updateBackgroundImage("pet_play_edit_side_cell0")
                cell.viewModel = viewModels[indexPath.section].sectionCells[indexPath.row]
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PJDogPlayEditTableViewCell",
                                                         for: indexPath) as! PJDogPlayEditTableViewCell
                cell.updateBackgroundImage("pet_play_edit_side_cell1")
                cell.viewModel = viewModels[indexPath.section].sectionCells[indexPath.row]
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PJDogPlayEditTableViewCell",
                                                         for: indexPath) as! PJDogPlayEditTableViewCell
                cell.updateBackgroundImage("pet_play_edit_side_cell1")
                cell.viewModel = viewModels[indexPath.section].sectionCells[indexPath.row]
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PJDogPlayEditOldTableViewCell", for: indexPath) as! PJDogPlayEditOldTableViewCell
                cell.viewModel = viewModels[indexPath.section].sectionCells[indexPath.row]
                return cell
            }
        }
    }
}

extension PJDogPlayEditTableView {
    struct ViewModel {
        var sectionTitle: String
        var sectionCells: [PJDogPlayEditTableViewCell.ViewModel]
        
        init() {
            sectionTitle = ""
            sectionCells = [PJDogPlayEditTableViewCell.ViewModel]()
        }
    }
}
