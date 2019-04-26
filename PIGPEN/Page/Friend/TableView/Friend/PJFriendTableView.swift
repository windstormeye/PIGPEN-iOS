//
//  PJTableView.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/26.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJFriendTableView: UITableView {
    var viewModel = [PJUser.FriendModel]()
    
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
        
        register(UINib(nibName: "PJFriendTableViewCell", bundle: nil), forCellReuseIdentifier: "PJFriendTableViewCell")
    }
}

extension PJFriendTableView: UITableViewDelegate {
    
}

extension PJFriendTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.count
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PJFriendTableViewCell", for: indexPath) as! PJFriendTableViewCell
        
        return cell
    }
}
