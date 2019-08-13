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

final class MapContainerView: BaseView {
    
    // MARK: Properties
    private var locationManager = CLLocationManager()
    lazy var focusCamera: Driver<Void> = {
        return self.focusMyLocationButton.rx.tap
            .mapToVoid()
            .asDriverOnErrorJustComplete()
    }()
    
    lazy var writeMemory: Driver<Void> = {
        return self.writeMemoryButton.rx.tap
            .mapToVoid()
            .asDriverOnErrorJustComplete()
    }()
    
    lazy var regionDidChangeAnimated: Driver<Bool> = {
        return self.mapView.rx.regionDidChangeAnimated.asDriverOnErrorJustComplete()
    }()
    
    lazy var updateLocation: Driver<CLLocationCoordinate2D> = {
        return self.mapView.rx.didUpdate.asDriverOnErrorJustComplete()
    }()
    
    lazy var didChangeVisibleRegion: Driver<MKMapView> = {
        return self.mapView.rx.didChangeVisibleRegion.asDriverOnErrorJustComplete()
    }()
    
    // MARK: UI Component
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        return mapView
    }()
    
    private var focusMyLocationButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Focus", for: .normal)
        btn.backgroundColor = .red
        return btn
    }()
    
    private var writeMemoryButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Write", for: .normal)
        btn.backgroundColor = .red
        return btn
    }()
    
    private var buttonStackView: UIStackView = {
        let stView = UIStackView()
        stView.axis = .vertical
        stView.distribution = .equalSpacing
        stView.alignment    = .leading
        stView.spacing = 10
        return stView
    }()
    
    private var searchContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private var searchDescLabel: UILabel = {
        let label = UILabel()
        label.text = "핀을 움직여 카드의 위치를 설정하세요."
        label.textColor = UIColor.grey4()
        label.font = UIFont.medium(size: 14)
        return label
    }()
    
    override init() {
        super.init()
        self.locationManagerInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(controlBy viewController: BaseViewController) {
        fatalError("init(controlBy:) has not been implemented")
    }
    
    override func setupUI() {
        self.buttonStackView.addArrangedSubview(self.focusMyLocationButton)
        self.buttonStackView.addArrangedSubview(self.writeMemoryButton)
        self.searchContainerView.addSubview(self.searchDescLabel)
        
        self.addSubview(self.mapView)
        self.addSubview(self.buttonStackView)
        self.addSubview(self.searchContainerView)
        
        self.layout()
    }
    
    private func locationManagerInit() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
    }
}

// MARK: draw UI
extension MapContainerView {
    private func layout() {
        self.mapView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        self.buttonStackView.snp.makeConstraints {
            $0.right.equalTo(self.safeArea.right).offset(-18)
            $0.bottom.equalTo(self.searchContainerView.snp.top).offset(-10)
        }
        
        self.searchContainerView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(188 + self.bottomSafeAreaInset)
        }
        
        self.searchDescLabel.snp.makeConstraints{
            $0.left.equalToSuperview().offset(24)
            $0.top.equalToSuperview().offset(30)
        }
    }
    
    private func buildSearchContainer(){
        
    }
}
