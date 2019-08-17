//
//  SetPlaceViewController.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/13.
//  Copyright © 2019 Zedd. All rights reserved.
//

import UIKit

import MapKit
import RIBs
import RxSwift
import RxCocoa

extension SetPlaceViewController: ViewControllable { }
final class SetPlaceViewController: BaseViewController {
    
    // MARK: Properties
    private lazy var mapContainerView = MapContainerView(controlBy: self)
    private let currentLocation: BehaviorSubject<CLLocationCoordinate2D> = BehaviorSubject(value: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    private let searchResult = PublishSubject<SearchPlaceItemViewModel>()
    private let regionRadius: CLLocationDistance = 500
    private let viewModel = SetPlaceViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigation()
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.mapContainerView
    }
    
    override func setupUI() {
        let frameImage = UIImageView()
        frameImage.image = UIImage(named: "alram")
        self.view.addSubview(frameImage)
        
        frameImage.snp.makeConstraints {
            $0.width.equalTo(64)
            $0.height.equalTo(74.5)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-(74.5 / 2))
        }
    }
    
    override func setupBind() {
        let foucusCamera = self.mapContainerView.focusCamera.withLatestFrom(self.currentLocation.asDriverOnErrorJustComplete())
        let didChangeVisibleRegion = self.mapContainerView.didChangeVisibleRegion
        let updateLocation = self.mapContainerView.updateLocation
        let searchLocation = self.mapContainerView.searchLocation
        let confirm = self.mapContainerView.confirmChangeLocation
        let setLocation = PublishSubject<SearchPlaceItemViewModel>()
        
        searchLocation.drive(onNext: { [weak self] _ in
            self?.navigationController?.pushViewController(SearchPlaceViewController(location: (self?.currentLocation)!,
                                                                                     searchResult: (self?.searchResult)! ),
                                                           animated: true)
        }).disposed(by: self.disposeBag)
        
        updateLocation.drive(self.currentLocation)
            .disposed(by: self.disposeBag)
        
        foucusCamera.drive(onNext: { [weak self] location in
            self?.setFocus(location: location)
        }).disposed(by: self.disposeBag)
        
        self.searchResult.do(onNext: { [weak self] place in
            self?.setFocus(location: place.coordinate)
        }).bind(to: setLocation).disposed(by: self.disposeBag)
        
        let input = SetPlaceViewModel.Input(reverseGeocodeLocationTrigger: didChangeVisibleRegion)
        let output = self.viewModel.transform(input: input)
        output.placeMark.do(onNext: {
            self.mapContainerView.searchLocationLabel.text = "\($0.administrativeArea ?? "") \($0.locality ?? "") \($0.subLocality ?? "") \($0.subThoroughfare ?? "")"
        })
            .map {
                SearchPlaceItemViewModel(with: $0)
        }.drive(setLocation).disposed(by: self.disposeBag)
        
        confirm.withLatestFrom(setLocation.asDriverOnErrorJustComplete())
            .drive(onNext: {
                print("selected Data: \($0.title)")
            }).disposed(by: self.disposeBag)
    }
    
    private func hideNavigation() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
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
