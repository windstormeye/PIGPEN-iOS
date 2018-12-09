//
//  PJAlbumTableView.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/12/2.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJAlbumTableView: UITableView {
    
    // MARK: - Public Property
    var tableModels: PJAlbumTableViewModel?
    
    // MARK: - Private Property
    private static let cellIndentifier = "PJAlbumTableViewCell"
    
    // MARK: - Public Methods
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methonds
    private func initView() {
        delegate = self
        dataSource = self
        
        backgroundColor = .white
        tableFooterView = UIView()
        estimatedRowHeight = 100
        
        register(UINib(nibName: "PJAlbumTableViewCell", bundle: nil),
                 forCellReuseIdentifier: "PJAlbumTableViewCell")
    }

}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension PJAlbumTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableModels = tableModels else { return 0 }
        return tableModels.albumCoverPhoto.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableModels = tableModels else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: PJAlbumTableView.cellIndentifier,
                                                 for: indexPath) as! PJAlbumTableViewCell
        let photoModel = tableModels.albumCoverPhoto[indexPath.row]
        let albumPhotosCount = tableModels.albumPhotosCount[indexPath.row]
        let cellModel = PJAlbumTableViewCell.PJAlbumTableViewCellModel(coverImage: photoModel.photoImage ?? UIImage(),
                                                                       albumTitleString: photoModel.photoTitle ?? "",
                                                                       albumPhotosCountString: String(albumPhotosCount))
        cell.setModel(cellModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - PJAlbumTableViewModel
extension PJAlbumTableView {
    struct PJAlbumTableViewModel {
        let albumCoverPhoto: [PJAlbumDataManager.Photo]
        let albumPhotosCount: [Int]
    }
}
