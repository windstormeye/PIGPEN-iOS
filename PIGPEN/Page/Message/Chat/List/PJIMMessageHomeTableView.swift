//
//  PJIMMessageHomeList.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/10.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJIMMessageHomeTableView: UITableView {
    var viewModels = [PJIM.MessageListCell]() {didSet{ reloadData() }}
    var cellSelected: ((Int) -> Void)?
    
    private let cellIndentifier = "PJIMMessageHomeTableViewCell"
    
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
        
        tableFooterView = UIView()
        
        register(UINib(nibName: "PJIMMessageHomeTableViewCell", bundle: nil),
                 forCellReuseIdentifier: "PJIMMessageHomeTableViewCell")
    }
}

extension PJIMMessageHomeTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellSelected?(indexPath.row)
    }
}

extension PJIMMessageHomeTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier,
                                                 for: indexPath) as! PJIMMessageHomeTableViewCell
        let viewModel = viewModels[indexPath.row]
        cell.setModel(PJIMMessageHomeTableViewCell.ViewModel(avatar: viewModel.avatar, nickName: viewModel.nickName, message: viewModel.message.textContent!, time: "\(viewModel.message.msgSentTime)", sendStatus: viewModel.message.msgStatus))
        return cell
    }
    
    
}
