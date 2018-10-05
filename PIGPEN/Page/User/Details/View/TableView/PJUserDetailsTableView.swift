//
//  PJUserDetailsTableView.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/5.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJUserDetailsTableView: UITableView, UITableViewDelegate,
UITableViewDataSource {
    
    static let userIdentifier = "PJUserSelfTableViewCell"
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initView() {
        tableFooterView = UIView()
        
        delegate = self
        dataSource = self
        
        register(UINib(nibName: "PJUserSelfTableViewCell", bundle: nil),
                 forCellReuseIdentifier: PJUserDetailsTableView.userIdentifier)
    }
    
    // MARK: - tableView delegate
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0: return 0
        default: return 28
        }
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 2,
                                              width: width, height: 30 - 2))
        let titleLabel = UILabel(frame: CGRect(x: 15, y: 0,
                                               width: headerView.width,
                                               height: headerView.height))
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = PJRGB(r: 102, g: 102, b: 102)
        titleLabel.textAlignment = .left
        headerView.addSubview(titleLabel)
        
        switch section {
        case 1:
            titleLabel.text = "我的真实宠物"
        case 2:
            titleLabel.text = "我的iDOG"
        case 3:
            titleLabel.text = "我的猪饲料"
        default: break
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: PJUserDetailsTableView.userIdentifier,
                                                     for: indexPath)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}
