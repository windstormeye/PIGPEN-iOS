//
//  PJMessageTableView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/5.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJMessageTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 该方法仅为声明作用，不应该作为初始化方法
    convenience init() {
        self.init(frame: CGRect(), style: .plain)
    }
    
    private func initView() {
        backgroundColor = .white
        
        delegate = self
        dataSource = self
        separatorStyle = .none
        
        register(UINib(nibName: "PJMessageTableViewCell", bundle: nil),
                 forCellReuseIdentifier: "PJMessageTableViewCell")
    }
}

extension PJMessageTableView: UITableViewDelegate {
    
}

extension PJMessageTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 480
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PJMessageTableViewCell", for: indexPath)
        return cell
    }
}
