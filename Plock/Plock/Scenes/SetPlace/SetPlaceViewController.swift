//
//  SetPlaceViewController.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/13.
//  Copyright © 2019 Zedd. All rights reserved.
//

import UIKit

import MapKit
import RxSwift
import RxCocoa

final class SetPlaceViewController: BaseViewController, SettableUINavigationBar {
    
    // MARK: Properties
    private lazy var mapContainerView = MapContainerView(controlBy: self)
    private let currentLocation: BehaviorSubject<CLLocationCoordinate2D> = BehaviorSubject(value: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    private let searchResult = PublishSubject<SearchPlaceItemViewModel>()
    private let regionRadius: CLLocationDistance = 10
    private let viewModel = SetPlaceViewModel()
    private let disposeBag = DisposeBag()
    private let confirmCompletion: (MemoryPlace) -> Void
    
    init(confirmCompletion: @escaping (MemoryPlace) -> Void) {
        self.confirmCompletion = confirmCompletion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigation()
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.mapContainerView
    }
    
    override func setupUI() {
        self.title = "위치 설정"
        self.setupBackButton()
        
        let frameImage = UIImageView()
        frameImage.image = UIImage(named: "alram")
        self.view.addSubview(frameImage)
        
        let contentImage = UIImageView()
        contentImage.image = UIImage(named: "empty")
        self.view.addSubview(contentImage)
        
        frameImage.snp.makeConstraints {
            $0.width.equalTo(64)
            $0.height.equalTo(74.5)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-((74.5 / 2) - 20))
        }
        
        contentImage.snp.makeConstraints {
            $0.top.equalTo(frameImage.snp.top).offset(5)
            $0.left.equalTo(frameImage.snp.left).offset(5)
            $0.right.equalTo(frameImage.snp.right).offset(-5)
            $0.bottom.equalTo(frameImage.snp.bottom).offset(-16)
        }
    }
    
    override func setupBind() {
        let foucusCamera = self.mapContainerView.focusCamera.withLatestFrom(self.currentLocation.asDriverOnErrorJustComplete())
        let didChangeVisibleRegion = self.mapContainerView.didChangeVisibleRegion
        let updateLocation = self.mapContainerView.updateLocation
        let searchLocation = self.mapContainerView.searchLocation
        let confirm = self.mapContainerView.confirmChangeLocation
        let chagnedAnimated = self.mapContainerView.regionDidChangeAnimated
        let setLocation = PublishSubject<SearchPlaceItemViewModel>()
        
        searchLocation.drive(onNext: { [weak self] _ in
            self?.navigationController?.pushViewController(SearchPlaceViewController(location: (self?.currentLocation)!,
                                                                                     searchResult: (self?.searchResult)! ),
                                                           animated: true)
        }).disposed(by: self.disposeBag)
        
        updateLocation.drive(self.currentLocation)
            .disposed(by: self.disposeBag)
        
        updateLocation.asObservable().take(1).subscribe(onNext: { [weak self] location in
            let coordinateRegion = MKCoordinateRegion(center: location,
                                                      latitudinalMeters: (self?.regionRadius ?? 100) * 2.0,
                                                      longitudinalMeters: (self?.regionRadius ?? 100) * 2.0)
            self?.mapContainerView.mapView.setRegion(coordinateRegion, animated: true)
        }).disposed(by: self.disposeBag)
        
        foucusCamera.drive(onNext: { [weak self] location in
            self?.setFocus(location: location)
        }).disposed(by: self.disposeBag)
        
        confirm.withLatestFrom(setLocation.asDriverOnErrorJustComplete())
            .drive(onNext: { [weak self] placemark in
                let memory = MemoryPlace()
                memory.address = placemark.subTitle
                memory.latitude = placemark.coordinate.latitude
                memory.longitude = placemark.coordinate.longitude
                self?.confirmCompletion(memory)
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: self.disposeBag)
        
        self.searchResult.do(onNext: { [weak self] place in
            self?.setFocus(location: place.coordinate)
            self?.mapContainerView.searchLocationLabel.text = place.title
        }).bind(to: setLocation).disposed(by: self.disposeBag)
        
        let locationTrigger = chagnedAnimated.withLatestFrom(didChangeVisibleRegion)
        
        let input = SetPlaceViewModel.Input(reverseGeocodeLocationTrigger: locationTrigger)
        let output = self.viewModel.transform(input: input)
        output.placeMark.do(onNext: {
            self.mapContainerView.searchLocationLabel.text = "\($0.administrativeArea ?? "") \($0.locality ?? "") \($0.subLocality ?? "") \($0.subThoroughfare ?? "")"
        }).map {
            SearchPlaceItemViewModel(with: $0)
        }
        .drive(setLocation)
        .disposed(by: self.disposeBag)
    }
}

// MARK: function
extension SetPlaceViewController {
    private func setFocus(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegion(center: location,
                                                  latitudinalMeters: (self.regionRadius) * 2.0,
                                                  longitudinalMeters: (self.regionRadius) * 2.0)
        self.mapContainerView.mapView.setRegion(coordinateRegion, animated: true)
    }
}
