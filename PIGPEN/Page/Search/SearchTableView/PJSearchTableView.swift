//
//  PJSearchTableView.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/4/14.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJSearchTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        backgroundColor = .white
        
        dataSource = self
        delegate = self
        
        register(UINib(nibName: "PJSearchTableViewCell", bundle: nil),
                 forCellReuseIdentifier: "PJSearchTableViewCell")
    }
}

extension PJSearchTableView: UITableViewDelegate {
    
}

extension PJSearchTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PJSearchTableViewCell", for: indexPath)
        return cell
    }
}
