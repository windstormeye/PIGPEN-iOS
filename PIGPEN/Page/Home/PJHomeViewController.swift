//
//  HomeViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/9/25.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJHomeViewController: UIViewController, PJBaseViewControllerDelegate {
    
    private var locationManager = AMapLocationManager()
    private var refresher = UIRefreshControl()
    private var collectionView = PIGAroundPetCollectionView()
    
    private var coor = CLLocationCoordinate2D(latitude: 0, longitude: 0) {
        didSet {
            requestData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        initBaseView()
        titleString = ""
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: .refresh, for: .valueChanged)
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        let itemCount: CGFloat = 3
        let itemW = view.pj_width / itemCount - 2
        collectionViewLayout.itemSize = CGSize(width: itemW, height: itemW)
        collectionViewLayout.minimumLineSpacing = 0.5
        collectionViewLayout.minimumInteritemSpacing = 0.5
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        
        collectionView = PIGAroundPetCollectionView(frame: CGRect(x: 0, y: navigationBarHeight, width: view.pj_width, height: view.pj_height - navigationBarHeight - PJTABBAR_HEIGHT), collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.refreshControl = refresher
        view.addSubview(collectionView)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
        locationManager.locationTimeout = 3
        
        locationManager.requestLocation(withReGeocode: false, completionBlock: { [weak self] (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            guard let `self` = self else { return }
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let location = location {
                self.coor = location.coordinate
            }
        })
        
        
        if PJUser.shared.userModel.token == nil {
            let navVC = UINavigationController(rootViewController: PJWelcomeViewController())
            present(navVC, animated: true, completion: nil)
        }
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: .gotoLogin,
                                               name: .gotoLogin(),
                                               object: nil)
    }
}


extension PJHomeViewController: AMapLocationManagerDelegate {
    func amapLocationManager(_ manager: AMapLocationManager!, doRequireLocationAuth locationManager: CLLocationManager!) {
        locationManager.requestAlwaysAuthorization()
    }
}


extension PJHomeViewController {
    private func requestData() {
        PJPet.around(uid: String(PJUser.shared.userModel.uid),
                     latitude: String(coor.latitude),
                     longitude: String(coor.longitude),
                     page: 0,
                     complationHandler: {
                        self.collectionView.viewModels = $0
                        self.refresher.endRefreshing()
        }) {
            PJHUD.shared.showError(view: self.view, text: $0.errorMsg)
            self.refresher.endRefreshing()
        }
    }
}

extension PJHomeViewController {
    @objc
    fileprivate func refresh() {
        requestData()
    }
    
    @objc fileprivate func gotoLoginPage() {
        let navVC = UINavigationController(rootViewController: PJUserLoginViewController())
        present(navVC, animated: true, completion: nil)
    }
}

private extension Selector {
    static let refresh = #selector(PJHomeViewController.refresh)
    static let gotoLogin = #selector(PJHomeViewController.gotoLoginPage)
}
