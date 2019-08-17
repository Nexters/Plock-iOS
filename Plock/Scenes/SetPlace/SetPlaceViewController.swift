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
    private let regionRadius: CLLocationDistance = 1000
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
    
    override func setupBind() {
        let foucusCamera = self.mapContainerView.focusCamera.withLatestFrom(self.currentLocation.asDriverOnErrorJustComplete())
        let didChangeVisibleRegion = self.mapContainerView.didChangeVisibleRegion
        let updateLocation = self.mapContainerView.updateLocation
        let searchLocation = self.mapContainerView.searchLocation
        
        searchLocation.drive(onNext: { [weak self] _ in
            self?.navigationController?.pushViewController(SearchPlaceViewController(location: (self?.currentLocation)!),
                                                           animated: true)
        }).disposed(by: self.disposeBag)
        
        updateLocation.drive(self.currentLocation)
            .disposed(by: self.disposeBag)
        
        foucusCamera.drive(onNext: { [weak self] location in
            let coordinateRegion = MKCoordinateRegion(center: location,
                                                      latitudinalMeters: (self?.regionRadius ?? 1000) * 2.0,
                                                      longitudinalMeters: (self?.regionRadius ?? 1000) * 2.0)
            self?.mapContainerView.mapView.setRegion(coordinateRegion, animated: true)
        }).disposed(by: self.disposeBag)
        
        let input = SetPlaceViewModel.Input(reverseGeocodeLocationTrigger: didChangeVisibleRegion)
        let output = self.viewModel.transform(input: input)
        
        output.placeMark.drive(onNext: {
            print("placeMark: \($0)")
            self.mapContainerView.searchLocationLabel.text = $0.name
        }).disposed(by: self.disposeBag)
    }
    
    private func hideNavigation() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
}
