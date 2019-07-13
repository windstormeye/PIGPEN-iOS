//
//  PJMessageTableView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/5.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJMessageTableView: UITableView {

    var cellSelected: ((Int) -> Void)?
    var cellLikeSelected: ((Bool) -> Void)?
    var cellCollectSelected: ((Bool) -> Void)?
    var cellMoreSelected: (() -> Void)?
    
    var viewModels = [PIGBlog.BlogContent]()
    
    var selectedIndex = 0
    
    
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

extension PJMessageTableView {
    func reloadCell(blogContent: PIGBlog.BlogContent) {
        let cell = self.cellForRow(at: IndexPath(row: selectedIndex, section: 0)) as! PJMessageTableViewCell
        cell.viewModel = blogContent
    }
}

extension PJMessageTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        cellSelected?(indexPath.row)
    }
}

extension PJMessageTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 480
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PJMessageTableViewCell", for: indexPath) as! PJMessageTableViewCell
        cell.viewModel = viewModels[indexPath.row]
        
        cell.likeSelected = {
            self.selectedIndex = self.indexPath(for: cell)!.row
            self.cellLikeSelected?($0)
        }
        
        cell.moreSelected = {
            self.selectedIndex = self.indexPath(for: cell)!.row
            self.cellMoreSelected?()
        }
        
        cell.collectSelected = {
            self.selectedIndex = self.indexPath(for: cell)!.row
            self.cellCollectSelected?($0)
        }
        
        return cell
    }
}
