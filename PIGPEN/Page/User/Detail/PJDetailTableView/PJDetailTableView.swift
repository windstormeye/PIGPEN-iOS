//
//  PJDetailTableView.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/15.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJDetailTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        delegate = self
        dataSource = self
        
        register(UINib(nibName: "PJDetailUserTableViewCell", bundle: nil),
                 forCellReuseIdentifier: "PJDetailUserTableViewCell")
    }
}

extension PJDetailTableView: UITableViewDelegate {
    
}

extension PJDetailTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PJDetailUserTableViewCell", for: indexPath) as! PJDetailUserTableViewCell
        cell.viewModel = PJDetailUserTableViewCell.ViewModel(avatar: 0, follows: 2333, money: 2333, level: 8.8)
        return cell
    }
    
    
}
