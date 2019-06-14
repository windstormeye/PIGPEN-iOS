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
    private var lineLocations = [CLLocation]()
    private var lineCoordinates = [CLLocationCoordinate2D]()
    
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
        // 禁止倾斜手势
        mapView.isRotateCameraEnabled = false
        // 用户模式跟踪
        mapView.userTrackingMode = .follow
        mapView.allowsBackgroundLocationUpdates = true
        
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
    func onDistanceSearchDone(_ request: AMapDistanceSearchRequest!, response: AMapDistanceSearchResponse!) {
        print(response.results[0].distance)
    }
}

extension PJDogPlayMapView: MAMapViewDelegate {
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay.isKind(of: MAPolyline.self) {
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 3
            renderer.strokeColor = PJRGB(255, 85, 67)
            renderer.lineJoinType = .init(2)
            renderer.lineCapType = .init(3)
            return renderer
        }
        return nil
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
        
        let coords = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                            longitude: location.coordinate.longitude)
        
        lineLocations.append(location)
        lineCoordinates.append(coords)
        let polyline = MAGeodesicPolyline(coordinates: &lineCoordinates, count: UInt(lineCoordinates.count))
        mapView.add(polyline)
        
        
        
        if lineLocations.last != nil {
            let lastCoord = lineLocations.last!
            //1.将两个经纬度点转成投影点
            let point1 = MAMapPointForCoordinate(CLLocationCoordinate2D(latitude: lastCoord.coordinate.latitude, longitude: lastCoord.coordinate.longitude))
            let point2 = MAMapPointForCoordinate(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            
            let distanceRequest = AMapDistanceSearchRequest()
            distanceRequest.type = 0
            distanceRequest.origins = [AMapGeoPoint.location(withLatitude: CGFloat(lastCoord.coordinate.latitude), longitude: CGFloat(lastCoord.coordinate.longitude))]
            distanceRequest.destination = AMapGeoPoint.location(withLatitude: CGFloat(location.coordinate.latitude), longitude: CGFloat(location.coordinate.longitude))

            //2.计算距离
//            let distance = MAMetersBetweenMapPoints(point1, point2);
//            print(distance)
            
//            print(lastCoord.course)
            
            AMapSearchAPI()?.aMapDistanceSearch(distanceRequest)
            
        } else {
        }
    }
}
