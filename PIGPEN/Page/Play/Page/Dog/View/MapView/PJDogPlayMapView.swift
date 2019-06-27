//
//  PJDogPlayMapView.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/6/13.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit
import CoreMotion
import Schedule


class PJDogPlayMapView: UIView {
    var stopLocation: ((UIImage, Int, CGFloat) -> Void)?
    var updateMsg: ((Int, CGFloat) -> Void)?
    /// 遛狗完成缩略图
    var mapImage: UIImage?
    
    private(set) var mapView: MAMapView = MAMapView()
    private let req = AMapWeatherSearchRequest()
    private var r = MAUserLocationRepresentation()
    private var locationManager = AMapLocationManager()

    // 圆滑轨迹线
    private var smoothedTrace = MAPolyline()
    // 圆滑轨迹点集合
    private var smoothedTracePoints = [MALonLatPoint]()
    // 初始轨迹点集合
    private var origTracePoints = [MALonLatPoint]()
    // 狗狗运动的总距离
    private var finalDistance: CGFloat = 0.0
    private var nowTimestamp = 0
    /// 地图是否加载完成
    private var isMapviewInit = false
    /// 遛狗结束后地图截图
    private var screenshotViewModel = ScreenShotViewModel()
    
    
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
        // 开启地图自定义样式
        mapView.customMapStyleEnabled = true;
        // 显示用户位置
        mapView.showsUserLocation = true
        // 禁止倾斜手势
        mapView.isRotateCameraEnabled = false
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
        
        locationManager.delegate = self
        locationManager.distanceFilter = 10
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.locatingWithReGeocode = true
        locationManager.startUpdatingLocation()
        
        nowTimestamp = Int(Date().timeIntervalSince1970)
    }
}

extension PJDogPlayMapView {
    /// 停止遛狗
    /// 返回遛狗缩略图
    func stopLocating() {
        locationManager.stopUpdatingLocation()
        // 主动停止时，调用一次保障时间的完整性
        updateMsg?(Int(Date().timeIntervalSince1970) - nowTimestamp, formatterDistance())
        
        mapView.takeSnapshot(in: CGRect(x: screenshotViewModel.left, y: screenshotViewModel.top, width: screenshotViewModel.right - screenshotViewModel.left, height: screenshotViewModel.bottom - screenshotViewModel.top - 30)) { (resultImage, status) in
            if status == 1 {
                self.stopLocation?(resultImage ?? UIImage(), Int(Date().timeIntervalSince1970) - self.nowTimestamp, self.formatterDistance())
            }
        }
    }
    
    private func formatterDistance() -> CGFloat {
        return CGFloat(Int(finalDistance)) * 0.001
    }
    
    private func updateScreenShotPoint(point: CGPoint) {
        guard isMapviewInit else { return }
        
        // 第一次记录
        if screenshotViewModel.left == 0 &&
            screenshotViewModel.top == 0 &&
            screenshotViewModel.right == 0 &&
            screenshotViewModel.bottom == 0 {
            
            let midScreenWidth = PJSCREEN_WIDTH / 2
            // 画出正方形区域
            screenshotViewModel.left = point.x - midScreenWidth - 20
            screenshotViewModel.top = point.y - midScreenWidth - 20
            screenshotViewModel.right = point.x + midScreenWidth + 20
            screenshotViewModel.bottom = point.y + midScreenWidth + 20
        } else {
            if point.x < screenshotViewModel.left {
                screenshotViewModel.left = point.x - 20
            } else if point.x > screenshotViewModel.right {
                screenshotViewModel.right = point.x + 20
            }
            if point.y < screenshotViewModel.top {
                screenshotViewModel.top = point.y - 20
            } else if point.y > screenshotViewModel.bottom {
                screenshotViewModel.bottom = point.y + 20
            }
        }
    }
}

extension PJDogPlayMapView: MAMapViewDelegate {
    func mapViewRequireLocationAuth(_ locationManager: CLLocationManager!) {
        locationManager.requestAlwaysAuthorization()
    }
    
    func mapInitComplete(_ mapView: MAMapView!) {
        isMapviewInit = true
    }
    
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
            let point1 = MAMapPointForCoordinate(CLLocationCoordinate2D(latitude: smoothedTracePoints.last!.lat,longitude: smoothedTracePoints.last!.lon))
            let point2 = MAMapPointForCoordinate(CLLocationCoordinate2D(latitude: smoothedTracePoints[smoothedTracePoints.count - 2].lat, longitude: smoothedTracePoints[smoothedTracePoints.count - 2].lon))

            finalDistance += CGFloat(MAMetersBetweenMapPoints(point1,point2))
            
            updateMsg?(Int(Date().timeIntervalSince1970) - nowTimestamp, formatterDistance())
        }
        
        updateScreenShotPoint(point: mapView.convert(coords, toPointTo: mapView))
    }
}

extension PJDogPlayMapView {
    struct ScreenShotViewModel {
        var left: CGFloat
        var top: CGFloat
        var right: CGFloat
        var bottom: CGFloat
        
        init() {
            left = 0
            top = 0
            right = 0
            bottom = 0
        }
    }
}
