//
//  PJTableView.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/26.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJFriendTableView: UITableView {
    var viewData = [PJUser.FriendModel]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PJFriendTableView: UITableViewDelegate {
    
}

extension PJFriendTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
