//
//  PJDogPlayEditTableView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/23.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJDogPlayEditTableView: UITableView {

    var viewModels = [PJDogPlayEditTableViewCell.ViewModel]() {
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
    }
}

extension PJDogPlayEditTableView: UITableViewDelegate {
    
}

extension PJDogPlayEditTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PJDogPlayEditTableViewCell",
                                                 for: indexPath) as! PJDogPlayEditTableViewCell
        cell.viewModel = viewModels[indexPath.row]
        return cell
    }
}
