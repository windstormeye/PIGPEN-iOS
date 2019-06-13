//
//  PJDogPlayMapView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/13.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit
import CoreMotion


class PJDogPlayMapView: UIView {

    private(set) var mapView: MAMapView = MAMapView()
    private let req = AMapWeatherSearchRequest()
    private var r = MAUserLocationRepresentation()
    private var locationManager = AMapLocationManager()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        AMapServices.shared().enableHTTPS = true
        
        req.type = AMapWeatherType.live
        
        mapView.frame = frame
        mapView.delegate = self
        mapView.showsScale = false
        mapView.showsCompass = false
        // 设置罗盘原点位置
        mapView.compassOrigin = CGPoint(x: PJSCREEN_WIDTH - 50, y: 30)
        // 开启地图自定义样式
        mapView.customMapStyleEnabled = true;
        // 显示显示用户位置
        mapView.showsUserLocation = true
        // 用户模式跟踪
        mapView.userTrackingMode = .follow
        mapView.zoomLevel = 19
        addSubview(mapView)
        
        r.image = UIImage(named: "map_userlocation")
        r.showsAccuracyRing = false
        mapView.update(r)
        
        var path = Bundle.main.bundlePath
        path.append("/mapView.data")
        let mapData = try! Data(contentsOf: URL(fileURLWithPath: path))
        let mapOptions = MAMapCustomStyleOptions()
        mapOptions.styleData = mapData
        mapView.setCustomMapStyleOptions(mapOptions)
        
        locationManager = AMapLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = 5
        locationManager.locatingWithReGeocode = true
        locationManager.startUpdatingLocation()
    }

}

extension PJDogPlayMapView: AMapSearchDelegate {
    
}

extension PJDogPlayMapView: MAMapViewDelegate {
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        let render = MAOverlayRenderer(overlay: overlay)
        var point = CGPoint(x: 200, y: 200)
        render?.renderLines(withPoints: &(point), pointCount: 1, strokeColors: [PJRGB(255, 85, 67)], drawStyleIndexes: [0], isGradient: false, lineWidth: 3, looped: false, lineJoinType: .init(2), lineCapType: .init(3), lineDash: .none)
        return render
    }
}

extension PJDogPlayMapView: AMapLocationManagerDelegate {
    func amapLocationManager(_ manager: AMapLocationManager!,
                             didUpdate location: CLLocation!,
                             reGeocode: AMapLocationReGeocode!) {
        print("location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy)
        
        if ((reGeocode) != nil) {
            print("reGeocode:%@", reGeocode)
        }
        
        
        let movingAnnotation = MAAnimatedAnnotation()
        
        var coords = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                            longitude: location.coordinate.longitude)
        
        movingAnnotation.addMoveAnimation(withKeyCoordinates:&(coords),
                                          count: 1,
                                          withDuration: 0.25,
                                          withName: nil,
                                          completeCallback:nil)
        mapView.addAnnotation(movingAnnotation)
    }
}
