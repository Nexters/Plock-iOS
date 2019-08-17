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
    private let memories = PublishSubject<[Memory]>()
    private let regionRadius: CLLocationDistance = 500
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
        self.rx.viewDidload
            .asDriver()
            .mapToVoid()
            .flatMapLatest { [weak self] in
                self?.rxFetchObservable() ?? Driver.never()
        }.drive(self.memories)
            .disposed(by: self.disposeBag)
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
        self.setBindMap()
        self.setBindReadViewController()
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

// MARK: Set Bind
extension ReadViewController {
    private func setBindMap() {
        let updateLocation = self.mapContainerView.updateLocation
        let foucusCamera = self.mapContainerView.focusCamera.withLatestFrom(self.currentLocation.asDriverOnErrorJustComplete())
        let writeMemory = self.mapContainerView.writeMemory
        
        updateLocation.drive(self.currentLocation)
            .disposed(by: self.disposeBag)
        
        foucusCamera.drive(onNext: { [weak self] location in
            let coordinateRegion = MKCoordinateRegion(center: location,
                                                      latitudinalMeters: (self?.regionRadius ?? 1000) * 2.0,
                                                      longitudinalMeters: (self?.regionRadius ?? 1000) * 2.0)
            self?.mapContainerView.mapView.setRegion(coordinateRegion, animated: true)
        }).disposed(by: self.disposeBag)
        
        writeMemory.drive(onNext: {
            //글쓰기 VC
        }).disposed(by: self.disposeBag)
        
        self.mapContainerView.mapView.rx.handleViewForAnnotation { mapView, annotation in
            guard let annotation = annotation as? MemoryAnnotation else { return nil }
            let identifier = MKMapViewDefaultClusterAnnotationViewReuseIdentifier
            
            return MemoryAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
    }
    
    private func setBindReadViewController(){
        self.titleSegment.rx.value.subscribe(onNext: { [weak self] segment in
            if segment == 0 {
                self?.changeMap()
            } else {
                self?.changeList()
            }
        }).disposed(by: self.disposeBag)
        
        self.memories.subscribe(onNext: { memory in
            let memories = memory.map {
                MemoryAnnotation(with: $0)
            }
            self.mapContainerView.mapView.addAnnotations(memories)
        }).disposed(by: self.disposeBag)
    }
}

// MARK: Create Observable
extension ReadViewController {
    private func rxFetchObservable() -> Driver<[Memory]> {
        return Observable.create { emit in
            let memories = CoreDataHandler.fetchObject()
            guard let memory = memories else {
                emit.onError(NSError(domain: "", code: 400, userInfo: nil))
                return Disposables.create()
            }
            
            if memory.isEmpty {
                emit.onError(NSError(domain: "", code: 400, userInfo: nil))
            }
            
            emit.onNext(memory)
            emit.onCompleted()
            return Disposables.create()
        }.asDriverOnErrorJustComplete()
    }
}
