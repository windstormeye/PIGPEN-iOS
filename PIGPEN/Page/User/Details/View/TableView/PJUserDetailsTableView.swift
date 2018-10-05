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
        return 90
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PJUserDetailsTableView.userIdentifier,
                                                 for: indexPath)
        
        return cell
    }
    
}
