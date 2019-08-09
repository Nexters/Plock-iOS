//
//  MapView.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/03.
//  Copyright © 2019 Zedd. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import MapKit

final class MapContainerView: BaseView{
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }()
    
    var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.mapView.showsUserLocation = true
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(controlBy viewController: BaseViewController) {
        fatalError("init(controlBy:) has not been implemented")
    }
    
    override func setupUI() {
        self.addSubview(self.mapView)
        self.layout()
    }
}


//MARK: draw UI
extension MapContainerView{
    func layout(){
        self.mapView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
