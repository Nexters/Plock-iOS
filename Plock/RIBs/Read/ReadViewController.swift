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

protocol ReadPresentableListener: class {
    
}

final class ReadViewController: BaseViewController, ReadPresentable, ReadViewControllable {
    
    // MARK: Properties
    weak var listener: ReadPresentableListener?
    private let currentLocation: BehaviorSubject<CLLocationCoordinate2D> = BehaviorSubject(value: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    private var gridView = PlaceGridView()
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    private var mapContainerView: MapContainerView = {
        let mapView = MapContainerView()
        return mapView
    }()
    
    private var titleSegment: UISegmentedControl = {
        let segment: UISegmentedControl = UISegmentedControl(items: ["지도", "리스트"])
        segment.sizeToFit()
        segment.selectedSegmentIndex = 0
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
    }
    
    override func setupUI() {
        self.view.backgroundColor = .white
        self.navigationItem.titleView = self.titleSegment
    }
    
    override func setupBind() {
        let didTapSegment = self.titleSegment.rx.value
        let regionDidChangeAnimated = self.mapContainerView.mapView.rx.regionDidChangeAnimated
        let updateLocation = self.mapContainerView.mapView.rx.didUpdate
        let didChangeVisibleRegion = self.mapContainerView.mapView.rx.didChangeVisibleRegion
//        let foucusCamera = 
        
        didTapSegment.subscribe(onNext: { [weak self] segment in
            if segment == 0 {
                self?.changeMap()
            } else {
                self?.changeList()
            }
        }).disposed(by: self.disposeBag)
        
        regionDidChangeAnimated.subscribe(onNext: {
                print("regionDidChangeAnimated: \($0)")
            }).disposed(by: self.disposeBag)
        
        updateLocation.bind(to: self.currentLocation)
            .disposed(by: self.disposeBag)
        
        didChangeVisibleRegion.subscribe(onNext: {
            print("didChangeVisibleRegion: \($0.centerCoordinate)")
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
