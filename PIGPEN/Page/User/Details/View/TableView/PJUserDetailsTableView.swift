//
//  PJUserDetailsTableView.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/5.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJUserDetailsTableView: UITableView {
    // MARK: - Public Properties
    var viewDelegate: PJUserDetailsTableViewDelegate?
    var userDetailsModel: PJUser.UserModel?
    var realPetModels: [PJRealPet.RealPetModel]?
    var virtualPetModels: [PJVirtualPet.VirtualPetModel]?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initView() {
        tableFooterView = UIView()
        separatorStyle = .none
        
        delegate = self
        dataSource = self
        
        register(UINib(nibName: "PJUserSelfTableViewCell", bundle: nil),
                 forCellReuseIdentifier: PJUserDetailsTableView.userIdentifier)
        register(PJUserDetailRealPetTableViewCell.self,
                 forCellReuseIdentifier: PJUserDetailsTableView.realPetIdentifier)
        register(PJUserDetailsVirtualPetTableViewCell.self,
                 forCellReuseIdentifier: PJUserDetailsTableView.virtualPetIdentifier)
        register(UINib(nibName: "PJUserDetailsMoneyTableViewCell", bundle: nil),
                 forCellReuseIdentifier: PJUserDetailsTableView.moneyIndentifier)
    }
}

fileprivate extension Selector {

}

extension PJUserDetailsTableView {
    
}

// MARK: - UITableView Delegate
extension PJUserDetailsTableView: UITableViewDelegate, UITableViewDataSource {
    static let userIdentifier = "PJUserSelfTableViewCell"
    static let realPetIdentifier = "PJUserDetailPetTableViewCell"
    static let virtualPetIdentifier = "PJUserDetailsVirtualPetTableViewCell"
    static let moneyIndentifier = "PJUserDetailsMoneyTableViewCell"
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 {
            return 50
        } else {
            return 100
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0: return 0
        case 3: return 1
        default: return 28
        }
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 2,
                                              width: width, height: 30 - 2))
        headerView.backgroundColor = .white
        let titleLabel = UILabel(frame: CGRect(x: 15, y: 0,
                                               width: headerView.width,
                                               height: headerView.height))
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = PJRGB(102, 102, 102)
        titleLabel.textAlignment = .left
        headerView.addSubview(titleLabel)
        
        let topLineView = UIView(frame: CGRect(x: 15, y: 0,
                                               width: width - 15, height: 1))
        topLineView.backgroundColor = .boderColor
        headerView.addSubview(topLineView)
        
        switch section {
        case 1:
            titleLabel.text = "我的真实宠物"
        case 2:
            titleLabel.text = "我的iDOG"
        default: break
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: PJUserDetailsTableView.userIdentifier,
                                                     for: indexPath) as! PJUserSelfTableViewCell
            cell.viewDelegate = self
            cell.model = userDetailsModel
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: PJUserDetailsTableView.realPetIdentifier,
                                                     for: indexPath) as! PJUserDetailRealPetTableViewCell
            cell.viewDelegate = self
            cell.realPetModels = realPetModels
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: PJUserDetailsTableView.virtualPetIdentifier,
                                                     for: indexPath) as! PJUserDetailsVirtualPetTableViewCell
            cell.viewDelegate = self
            cell.virtualPetModels = virtualPetModels
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: PJUserDetailsTableView.moneyIndentifier,
                                                     for: indexPath) as! PJUserDetailsMoneyTableViewCell
            cell.viewModel = PJUserDetailsMoneyTableViewCell.ViewModel(money: userDetailsModel?.money ?? 0)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - PJUserDetailRealPetTableViewCellDelegate
extension PJUserDetailsTableView: PJUserDetailRealPetTableViewCellDelegate {
    func PJUserDetailPetTableViewCellAvatarTapped() {
        viewDelegate?.PJUserDetailsTableViewToPetDetails()
    }
    
    func PJUserDetailPetTableViewCellNewPetTapped() {
        viewDelegate?.PJUserDetailsTableViewToNewPet()
    }
}

// MARK: - PJUserDetailsVirtualPetTableViewCellDelegate
extension PJUserDetailsTableView: PJUserDetailsVirtualPetTableViewCellDelegate {
    func PJUserDetailVirtualPetTableViewCellAvatarTapped() {
        viewDelegate?.PJUserDetailsTableViewVirtualPetToDetails()
    }
    
    func PJUserDetailVirtualPetTableViewCellNewPetTapped() {
        viewDelegate?.PJUserDetailsTableViewVirtualPetToNewPet()
    }
}

// MARK: - PJUserDetailsMoneyTableViewCellDelegate
extension PJUserDetailsTableView: PJUserDetailsMoneyTableViewCellDelegate {
    func PJUserDetailsMoneyTableViewCellStealButtonTapped() {
        viewDelegate?.PJUserDetailsTableViewMoneySteal()
    }
    
    func PJUserDetailsMoneyTableViewCellLookButtonTapped() {
        viewDelegate?.PJUserDetailsTableViewMoneyLook()
    }
}

// MARK: - PJUserSelfTableViewCellDelegate
extension PJUserDetailsTableView: PJUserSelfTableViewCellDelegate {
    func PJUserSelfLevelButtonTapped() {
        viewDelegate?.PJUserDetailsTableViewUserSelfLevel()
    }
    
    func PJUserSelfFollowButtonTapped() {
        viewDelegate?.PJUserDetailsTableViewUserSelfFollow()
    }
    
    func PJUserSelftStarButtonTapped() {
        viewDelegate?.PJUserDetailsTableViewUserSelfStar()
    }
}

// MARK: - PJUserDetailsTableViewDelegate
protocol PJUserDetailsTableViewDelegate {
    func PJUserDetailsTableViewToPetDetails()
    func PJUserDetailsTableViewToNewPet()
    func PJUserDetailsTableViewVirtualPetToDetails()
    func PJUserDetailsTableViewVirtualPetToNewPet()
    func PJUserDetailsTableViewMoneyLook()
    func PJUserDetailsTableViewMoneySteal()
    func PJUserDetailsTableViewUserSelfLevel()
    func PJUserDetailsTableViewUserSelfFollow()
    func PJUserDetailsTableViewUserSelfStar()
}

extension PJUserDetailsTableViewDelegate {
    func PJUserDetailsTableViewToPetDetails() {}
    func PJUserDetailsTableViewToNewPet() {}
    func PJUserDetailsTableViewVirtualPetToDetails() {}
    func PJUserDetailsTableViewVirtualPetToNewPet() {}
    func PJUserDetailsTableViewMoneyLook() {}
    func PJUserDetailsTableViewMoneySteal() {}
    func PJUserDetailsTableViewUserSelfLevel() {}
    func PJUserDetailsTableViewUserSelfFollow() {}
    func PJUserDetailsTableViewUserSelfStar() {}
}
