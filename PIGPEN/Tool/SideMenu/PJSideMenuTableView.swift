//
//  PJSideMenuTableView.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/5/5.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJSideMenuTableView: UITableView {
    var didSelectedCell: ((Int) -> Void)?
    
    private var itemNames = [String]()
    private var itemImageNames = [String]()
    
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
        
        layer.borderColor = PJRGB(240, 240, 240).cgColor
        layer.borderWidth = 0.5
        
        separatorStyle = .none
        
        delegate = self
        dataSource = self
        
        register(UINib(nibName: "PJSlideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "PJSlideMenuTableViewCell")
    }
    
    /// 数据源更新方法
    func update(_ itemNames: [String], _ itemImageNames: [String]) {
        self.itemNames = itemNames
        self.itemImageNames = itemImageNames
        
        reloadData()
    }
}

extension PJSideMenuTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PJSlideMenuTableViewCell", for: indexPath) as! PJSlideMenuTableViewCell
        cell.viewModel = PJSlideMenuTableViewCell.ViewModel(imageName: itemImageNames[indexPath.row],
                                                            title: itemNames[indexPath.row])
        return cell
    }
}

extension PJSideMenuTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectedCell?(indexPath.row)
    }
}
