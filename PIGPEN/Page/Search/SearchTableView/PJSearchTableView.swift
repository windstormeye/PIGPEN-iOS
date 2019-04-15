//
//  PJSearchTableView.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/14.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJSearchTableView: UITableView {
    var cellSelected: ((Int) -> Void)?
    var cellLikeButtonClick: (() -> Void)?
    var cellChatButtonClick: ((Int) -> Void)?
    
    var viewModels = [PJUser.UserModel]() {
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
        backgroundColor = .white
        tableFooterView = UIView()
        
        dataSource = self
        delegate = self
        
        register(UINib(nibName: "PJSearchTableViewCell", bundle: nil),
                 forCellReuseIdentifier: "PJSearchTableViewCell")
    }
}

extension PJSearchTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellSelected?(indexPath.row)
    }
}

extension PJSearchTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PJSearchTableViewCell", for: indexPath) as! PJSearchTableViewCell
        cell.viewModel = viewModels[indexPath.row]

        cell.chatButtonClick = {
            self.cellChatButtonClick?(indexPath.row)
        }
        return cell
    }
}
