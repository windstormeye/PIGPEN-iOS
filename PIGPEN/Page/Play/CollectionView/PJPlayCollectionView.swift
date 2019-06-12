//
//  PJPlayCollectionView.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/6/11.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit
import CollectionKit

class PJPlayCollectionView: UIView {
    
    let viewModels = [PJPet(), PJPet(), PJPet()]
    
    private var selectedIndexs = [Int]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        let margin = CGFloat(15)
        let itemSizeW = (pj_width - margin * 2 - 10) / 2
        
        // 宠物看板
        let cellLayout = FlowLayout(lineSpacing: 10, interitemSpacing: 10, justifyContent: .start, alignItems: .start, alignContent: .start).inset(by: UIEdgeInsets(top: 10, left: margin, bottom: 0, right: 0))
        let cellSizeSource = ClosureSizeSource { (index: Int, data: PJPet, size: CGSize) -> CGSize in
            return CGSize(width: itemSizeW, height: itemSizeW * 0.655)
        }
        let cellViewSource = ClosureViewSource(viewGenerator: { (viewModel: PJPet, index: Int) -> PJPlayCellView in
            let cell = PJPlayCellView.newInstance()
            return cell
        }) { (cell: PJPlayCellView, viewModel: PJPet, index: Int) in
            if self.selectedIndexs.contains(index) {
                cell.isSelected = true
            } else {
                cell.isSelected = false
            }
        }
        
        let cellprovider = BasicProvider(identifier: nil,
                                         dataSource: viewModels,
                                         viewSource: cellViewSource,
                                         sizeSource: cellSizeSource,
                                         layout: cellLayout,
                                         animator: nil) {
                                            if self.selectedIndexs.contains($0.index) {
                                                if self.selectedIndexs.index(of: $0.index) != nil {
                                                    self.selectedIndexs.remove(at: self.selectedIndexs.index(of: $0.index)!)
                                                }
                                            } else {
                                                self.selectedIndexs.append($0.index)
                                            }
                                            
                                            $0.setNeedsReload()
        }
        
        // 活动选项
        let footerLayout = RowLayout(justifyContent: .spaceEvenly).inset(by: UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0))
        let footerSizeSource = ClosureSizeSource { (index: Int, data: Int, size: CGSize) -> CGSize in
            return CGSize(width: 56, height: 66)
        }
        let footerViewSource = ClosureViewSource(viewGenerator: { (data: Int, index: Int) -> UIView in
            let finalView = UIView()
            
            let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 66, height: 66 * 0.61))
            
            let label = UILabel(frame: CGRect(x: 0, y: img.bottom + 10, width: 66, height: 15))
            label.textColor = PJRGB(184, 180, 180)
            label.font = UIFont.systemFont(ofSize: 14)
            label.textAlignment = .center
            
            switch index {
            case 0:
                img.image = UIImage(named: "dog_status_0_unselected")
                label.text = "吃饭"
            case 1:
                img.image = UIImage(named: "dog_status_1_unselected")
                label.text = "喝水"
            case 2:
                img.image = UIImage(named: "dog_status_2_unselected")
                label.text = "撸猫遛狗"
            default: break
            }
            
            finalView.addSubview(img)
            finalView.addSubview(label)
            
            return finalView
        }) { (item: UIView, data: Int, index: Int) in
            
        }
        
        let footerProvider = BasicProvider(identifier: "footer",
                                           dataSource: [0, 1, 2],
                                           viewSource: footerViewSource,
                                           sizeSource: footerSizeSource,
                                           layout: footerLayout,
                                           animator: nil)
        
        let finalProvider = ComposedProvider(sections: [cellprovider, footerProvider])
        let collectionView = CollectionView(frame: CGRect(x: 0, y: navigationBarHeight, width: pj_width, height: pj_height - navigationBarHeight))
        collectionView.provider = finalProvider
        addSubview(collectionView)
    }
}

private extension Selector {
    static let cellTap = #selector(PJPlayCollectionView.cellTap(sender:))
}

extension PJPlayCollectionView {
    @objc
    fileprivate func cellTap(sender: UIButton) {
       
    }
}
