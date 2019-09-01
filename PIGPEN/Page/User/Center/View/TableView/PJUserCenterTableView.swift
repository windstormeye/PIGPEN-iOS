//
//  PJUserDetailsTableView.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/10/5.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJUserCenterTableView: UITableView {
    var createPet: (() -> Void)?
    
    var userDetailsModel: PJUser.UserModel?
    
    var pets = [PJPet.Pet]() {
        didSet {
            cellHeights = Array(repeating: 70, count: pets.count)
            reloadData()
        }
    }
    
    private var addButton = UIButton()
    private var createButton = UIButton()
    private var cellHeights = [CGFloat]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initView() {
        separatorStyle = .none
        delegate = self
        dataSource = self
        
        let footerView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: pj_width, height: 50))
        let createButton = UIButton(frame: CGRect(x: 0, y: 0, width: pj_width * 0.8, height: 40))
        footerView.addSubview(createButton)
        createButton.layer.cornerRadius = createButton.pj_height / 2
        createButton.backgroundColor = PJRGB(255, 85, 67)
        createButton.setTitle("创建宠物", for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        createButton.center = footerView.center
        createButton.isHidden = false
        createButton.addTarget(self, action: .addPet, for: .touchUpInside)
        self.createButton = createButton
        
        let addButton = UIButton(frame: CGRect(x: 0, y: 0, width: pj_width * 0.8, height: 40))
        footerView.addSubview(addButton)
        addButton.layer.cornerRadius = addButton.pj_height / 2
        addButton.setTitle("添加宠物", for: .normal)
        addButton.setImage(UIImage(named: "user_add_pet"), for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        addButton.center = footerView.center
        addButton.isHidden = true
        addButton.addTarget(self, action: .addPet, for: .touchUpInside)
        self.addButton = addButton
        
        tableFooterView = footerView

        
        register(UINib(nibName: "PJDetailUserTableViewCell", bundle: nil),
                 forCellReuseIdentifier: PJUserCenterTableView.userIdentifier)
        register(UINib(nibName: "PJUserCenterPetTableViewCell", bundle: nil),
                 forCellReuseIdentifier: PJUserCenterTableView.petIdentifier)
    }
    
    override func reloadData() {
        super.reloadData()
        
        if pets.count == 0 {
            createButton.isHidden = false
            addButton.isHidden = true
        } else {
            createButton.isHidden = true
            addButton.isHidden = false
        }
    }
}

fileprivate extension Selector {
    static let addPet = #selector(PJUserCenterTableView.addPet)
}

extension PJUserCenterTableView {
    @objc
    fileprivate func addPet() {
        createPet?()
    }
}

// MARK: - UITableView Delegate
extension PJUserCenterTableView: UITableViewDelegate, UITableViewDataSource {
    static let userIdentifier = "PJUserSelfTableViewCell"
    static let petIdentifier = "PJUserCenterPetTableViewCell"
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return pets.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 用户
        guard indexPath.section == 1 else {
            return 70
        }
        // 宠物
        return cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: PJUserCenterTableView.userIdentifier,
                                                     for: indexPath) as! PJDetailUserTableViewCell
            cell.viewModel = PJDetailUserTableViewCell.ViewModel(avatar: 0, firstCount: String(8.5).count, firstTitle: "\(8.5)\n评分", secondCount: String(231).count, secondTitle: "\(231)\n关注", threeCount: String(14).count, threeTitle: "\(14)\n收藏")
            cell.selectionStyle = .none
            cell.isHiddenChatButton(true)
            cell.isHiddenAvatarEditImageView(false)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: PJUserCenterTableView.petIdentifier, for: indexPath) as! PJUserCenterPetTableViewCell
            cell.selectionStyle = .none
            cell.pet = pets[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PJUserCenterPetTableViewCell
        if cellHeights[indexPath.row] != 70 {
            cellHeights[indexPath.row] += 50
        } else {
            cellHeights[indexPath.row] -= 50
        }
        
        
        switch cell.clickType {
        case .none:
            cell.clickType = .big
        case .big:
            cell.clickType = .small
        case .small:
            cell.clickType = .big
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}
