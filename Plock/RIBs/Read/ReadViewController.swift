//
//  ReadViewController.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/03.
//  Copyright © 2019 Zedd. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa
import MapKit
import UIKit

protocol ReadPresentableListener: class { }

final class ReadViewController: BaseViewController, ReadPresentable, ReadViewControllable {
    
    // MARK: Properties
    weak var listener: ReadPresentableListener?
    private let currentLocation: BehaviorSubject<CLLocationCoordinate2D> = BehaviorSubject(value: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    private let regionRadius: CLLocationDistance = 1000
    private var gridView = PlaceGridView()
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    private lazy var mapContainerView: MapContainerView = {
        let mapView = MapContainerView(controlBy: self)
        return mapView
    }()
    
    private var titleSegment: UISegmentedControl = {
        let segment: UISegmentedControl = UISegmentedControl(items: ["지도", "리스트"])
        segment.sizeToFit()
        segment.selectedSegmentIndex = 0
        segment.tintColor = .mainBlue()
        return segment
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.mapContainerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("coreData: \(CoreDataHandler.fetchObject())")
    }
    
    override func setupUI() {
        self.view.backgroundColor = .white
        self.navigationItem.titleView = self.titleSegment
    }
    
    override func setupBind() {
        self.setBindMap()
        self.titleSegment.rx.value.subscribe(onNext: { [weak self] segment in
            if segment == 0 {
                self?.changeMap()
            } else {
                self?.changeList()
            }
        }).disposed(by: self.disposeBag)
    }
}

// MARK: Draw UI
extension ReadViewController {
    private func changeMap() {
        self.view = self.mapContainerView
    }
    
    private func changeList() {
        self.view = self.gridView
    }
}

// MARK: Set Map
extension ReadViewController {
    private func setBindMap() {
        let regionDidChangeAnimated = self.mapContainerView.regionDidChangeAnimated
        let updateLocation = self.mapContainerView.updateLocation
        let foucusCamera = self.mapContainerView.focusCamera.withLatestFrom(self.currentLocation.asDriverOnErrorJustComplete())
        let writeMemory = self.mapContainerView.writeMemory
        
        regionDidChangeAnimated.drive(onNext: {
            print("regionDidChangeAnimated: \($0)")
        }).disposed(by: self.disposeBag)
        
        updateLocation.drive(self.currentLocation)
            .disposed(by: self.disposeBag)
        
        foucusCamera.drive(onNext: { [weak self] location in
            let coordinateRegion = MKCoordinateRegion(center: location,
                                                      latitudinalMeters: (self?.regionRadius ?? 1000) * 2.0,
                                                      longitudinalMeters: (self?.regionRadius ?? 1000) * 2.0)
            self?.mapContainerView.mapView.setRegion(coordinateRegion, animated: true)
        }).disposed(by: self.disposeBag)
        
        writeMemory.drive(onNext: {
            
        }).disposed(by: self.disposeBag)
    }
}
