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

    var updateMsg: ((Int, Double) -> Void)?
    
    private(set) var mapView: MAMapView = MAMapView()
    private let req = AMapWeatherSearchRequest()
    private var r = MAUserLocationRepresentation()
    private var locationManager = AMapLocationManager()
    private var lineLocations = [CLLocation]()
    private var lineCoordinates = [CLLocationCoordinate2D]()
    // 圆滑轨迹线
    private var smoothedTrace = MAPolyline()
    // 圆滑轨迹点集合
    private var smoothedTracePoints = [MALonLatPoint]()
    // 初始轨迹点集合
    private var origTracePoints = [MALonLatPoint]()
    // 狗狗运动的总距离
    private var finalDistance = 0.0
    // 狗狗运动时间
    private var timer: Timer?
    private var durationSeconds = 0
    private var durationHours = 0
    
    private var currentTimeString = "0 min"
    
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
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: .repeatTimer,
                                     userInfo: nil,
                                     repeats: true)
    }
}

extension PJDogPlayMapView {
    func stopLocating() {
        locationManager.stopUpdatingLocation()
        timer!.invalidate()
        
        locationManager = AMapLocationManager()
    }
    
    @objc
    fileprivate func repeatTimer() {
        durationSeconds += 1
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
        let coords = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                            longitude: location.coordinate.longitude)
        
        lineLocations.append(location)
        lineCoordinates.append(coords)
        
        let oPoint = MALonLatPoint()
        oPoint.lat = coords.latitude
        oPoint.lon = coords.longitude
        origTracePoints.append(oPoint)
        
        
        let tool = MASmoothPathTool()
        tool.intensity = 3
        tool.threshHold = 0.3
        tool.noiseThreshhold = 10
        
        let smoothPoints = tool.pathOptimize(origTracePoints)
        if smoothPoints != nil {
            smoothedTracePoints = smoothPoints!
        }
        
        var pCoords:[CLLocationCoordinate2D] = Array()
        for onePoint in smoothedTracePoints {
            let cor = CLLocationCoordinate2D(latitude: onePoint.lat, longitude: onePoint.lon)
            pCoords.append(cor)
        }
        smoothedTrace = MAPolyline.init(coordinates: &pCoords, count: UInt(pCoords.count))
        mapView.add(self.smoothedTrace)
        
        if smoothedTracePoints.last != nil && smoothedTracePoints.count > 2 {
            let point1 = MAMapPointForCoordinate(CLLocationCoordinate2D(latitude: smoothedTracePoints.last!.lat, longitude: smoothedTracePoints.last!.lon))
            let point2 = MAMapPointForCoordinate(CLLocationCoordinate2D(latitude: smoothedTracePoints[smoothedTracePoints.count - 2].lat, longitude: smoothedTracePoints[smoothedTracePoints.count - 2].lon))
            
            finalDistance += MAMetersBetweenMapPoints(point1,point2)
            
            updateMsg?(durationSeconds, finalDistance)
        }
    }
}


private extension Selector {
    static let repeatTimer = #selector(PJDogPlayMapView.repeatTimer)
}
