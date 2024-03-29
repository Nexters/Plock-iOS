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
    
    lazy var searchLocation: Driver<Void> = {
        return self.searchButton.rx.tap
            .asDriverOnErrorJustComplete()
    }()
    
    lazy var regionDidChangeAnimated: Driver<Bool> = {
        return self.mapView.rx.regionDidChangeAnimated.asDriverOnErrorJustComplete()
    }()
    
    lazy var didChangeVisibleRegion: Driver<CLLocationCoordinate2D> = {
        return self.mapView.rx.didChangeVisibleRegion.asDriverOnErrorJustComplete()
    }()
    
    lazy var touchedMap: PublishSubject<Void> = PublishSubject<Void>()
    lazy var didTapAnnotationView: Driver<MKAnnotation> = self.mapView.rx.didTapAnnotationView.asDriverOnErrorJustComplete()
    lazy var updateLocation: Driver<[CLLocation]> = self.locationManager.rx.didUpdateLocations.asDriverOnErrorJustComplete()
    lazy var confirmChangeLocation: Driver<Void> = self.searchConfirmButton.rx.tap.asDriverOnErrorJustComplete()
    lazy var availableFoucs = BehaviorSubject<Bool>(value: true)
    
    private var tapGestureRecognizer: UITapGestureRecognizer!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    
    // MARK: UI Component
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        return mapView
    }()
    
    private var focusMyLocationButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "location"), for: .normal)
        return btn
    }()
    
    private var writeMemoryButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "edit"), for: .normal)
        return btn
    }()
    
    private var buttonStackView: UIStackView = {
        let stView = UIStackView()
        stView.axis = .vertical
        stView.distribution = .equalSpacing
        stView.alignment    = .leading
        stView.spacing = 0
        return stView
    }()
    
    private var searchContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 25
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
    
    private var searchButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.mainBlue().cgColor
        button.layer.cornerRadius = 5
        return button
    }()
    
    var searchLocationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bold(size: 16)
        label.textColor = UIColor.grey2()
        label.text = "서울특별시 강남구"
        return label
    }()
    
    private var searchImage: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "icSearchActive")
        return imgView
    }()
    
    private var searchConfirmButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("설정하기", for: .normal)
        btn.titleLabel?.font = UIFont.bold(size: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .mainBlue()
        btn.layer.cornerRadius = 21
        return btn
    }()
    
    private let disposeBag = DisposeBag()
    
    required init(controlBy viewController: BaseViewController) {
        super.init(controlBy: viewController)
        self.locationManagerInit()
        self.addGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.mapView.removeGestureRecognizer(self.panGestureRecognizer)
        self.mapView.removeGestureRecognizer(self.tapGestureRecognizer)
        self.locationManager.stopUpdatingLocation()
    }
    
    override func setupUI() {
        self.buttonStackView.addArrangedSubview(self.focusMyLocationButton)
        self.buttonStackView.addArrangedSubview(self.writeMemoryButton)
        self.searchContainerView.addSubview(self.searchDescLabel)
        self.searchContainerView.addSubview(self.searchButton)
        self.searchContainerView.addSubview(self.searchLocationLabel)
        self.searchContainerView.addSubview(self.searchImage)
        self.searchContainerView.addSubview(self.searchConfirmButton)
        self.addSubview(self.mapView)
        self.addSubview(self.buttonStackView)
        self.addSubview(self.searchContainerView)
        
        self.layout()
        
        if self.vc is ReadViewController {
            self.searchContainerView.isHidden = true
            self.searchContainerView.snp.updateConstraints {
                $0.height.equalTo(0)
            }
        } else {
            self.writeMemoryButton.isHidden = true
        }
    }
    
    override func setupBind() {
        self.focusCamera
            .mapTo(true)
            .drive(self.availableFoucs)
            .disposed(by: self.disposeBag)
        
        self.touchedMap
            .mapTo(false)
            .bind(to: self.availableFoucs)
            .disposed(by: self.disposeBag)
    }
    
    private func locationManagerInit() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
    }
    
    private func addGesture(){
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(triggerTouchAction))
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(triggerTouchAction))
        self.panGestureRecognizer.delegate = self
        self.mapView.addGestureRecognizer(self.panGestureRecognizer)
        self.mapView.addGestureRecognizer(self.tapGestureRecognizer)
    }
    
    @objc
    private func triggerTouchAction(){
        self.touchedMap.onNext(())
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
            $0.bottom.equalTo(self.searchContainerView.snp.top).offset(-20)
        }
        
        self.searchContainerView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(188 + self.bottomSafeAreaInset)
        }
        
        self.searchDescLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.top.equalToSuperview().offset(30)
        }
        
        self.searchButton.snp.makeConstraints {
            $0.left.equalTo(self.searchDescLabel.snp.left)
            $0.top.equalTo(self.searchDescLabel.snp.bottom).offset(4)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(43)
        }
        
        self.searchImage.snp.makeConstraints {
            $0.left.equalTo(self.searchButton.snp.left).offset(12)
            $0.centerY.equalTo(self.searchButton)
        }
        
        self.searchLocationLabel.snp.makeConstraints {
            $0.left.equalTo(self.searchImage.snp.right).offset(4)
            $0.right.lessThanOrEqualTo(self.searchButton.snp.right).offset(-12)
            $0.centerY.equalTo(self.searchButton)
        }
        
        self.searchConfirmButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.height.equalTo(42)
            $0.top.equalTo(self.searchButton.snp.bottom).offset(20)
        }
    }
}

extension MapContainerView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
