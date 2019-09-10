//
//  ReadViewController.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/03.
//  Copyright © 2019 Zedd. All rights reserved.
//

import RIBs
import MapKit
import UIKit

import RxSwift
import RxCocoa
import RxDataSources

protocol ReadPresentableListener: class {
    func triggerFetchMemories()
    func triggerMeasureDistance(with currentLocation: CLLocation)
    func goWrite()
    func goDetail(memories: [MemoryPlace])
}

final class ReadViewController: BaseViewController, ReadViewControllable, SettableUINavigationBar {
    // MARK: Properties
    weak var listener: ReadPresentableListener?
    private let currentLocation: BehaviorSubject<CLLocationCoordinate2D> = BehaviorSubject(value: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    private let regionRadius: CLLocationDistance = 10
    private var gridView = PlaceGridView()
    private let disposeBag = DisposeBag()
    private var dataSource: RxCollectionViewSectionedAnimatedDataSource<SectionOfMemory>?
    var triggerDrawCollectionView: PublishSubject<[SectionOfMemory]> = PublishSubject<[SectionOfMemory]>()
    
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
        self.rx
            .viewWillAppear
            .mapToVoid()
            .subscribe(onNext: {
                self.listener?.triggerFetchMemories()
            })
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
        self.setupCollectionView()
        self.setupCollectionViewLayout()
        self.setupBackButton()
    }
    
    override func setupBind() {
        self.setBindMap()
        self.setBindReadViewController()
        self.triggerDrawCollectionView
            .do(onNext: { _ in self.gridView.hideEmptyView() })
            .bind(to: self.gridView
                .collectionView
                .rx
                .items(dataSource: self.dataSource!))
            .disposed(by: self.disposeBag)
        
        self.triggerDrawCollectionView.subscribe(onNext: { [weak self] sections in
            if sections[0].items.isEmpty {
                self?.gridView.showEmptyView()
            } else {
                self?.gridView.hideEmptyView()
            }
        }).disposed(by: self.disposeBag)
        
        self.gridView.collectionView.rx
            .modelSelected(MemoryPlace.self)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if !$0.isLock {
                    self.listener?.goDetail(memories: [$0])
                }
        }).disposed(by: self.disposeBag)
    }
}

// MARK: Draw UI
extension ReadViewController {
    private func changeMap() {
        self.view = self.mapContainerView
        self.showNavigation()
    }
    
    private func changeList() {
        self.view = self.gridView
        self.hideNavigation()
    }
}

// MARK: Set Bind
extension ReadViewController {
    private func setBindMap() {
        let updateLocation = self.mapContainerView.updateLocation
        let foucusCamera = self.mapContainerView.focusCamera.withLatestFrom(self.currentLocation.asDriverOnErrorJustComplete())
        let writeMemory = self.mapContainerView.writeMemory
        let didTapAnnotation = self.mapContainerView.didTapAnnotationView
        
        updateLocation.asObservable().take(1).subscribe(onNext: { [weak self] location in
            let coordinateRegion = MKCoordinateRegion(center: location,
                                                      latitudinalMeters: (self?.regionRadius ?? 100) * 2.0,
                                                      longitudinalMeters: (self?.regionRadius ?? 100) * 2.0)
            self?.mapContainerView.mapView.setRegion(coordinateRegion, animated: true)
        }).disposed(by: self.disposeBag)
        
        updateLocation.drive(self.currentLocation)
            .disposed(by: self.disposeBag)
        
        foucusCamera.drive(onNext: { [weak self] location in
            let coordinateRegion = MKCoordinateRegion(center: location,
                                                      latitudinalMeters: (self?.regionRadius ?? 100) * 2.0,
                                                      longitudinalMeters: (self?.regionRadius ?? 100) * 2.0)
            self?.mapContainerView.mapView.setRegion(coordinateRegion, animated: true)
        }).disposed(by: self.disposeBag)
        
        writeMemory.drive(onNext: {
            self.listener?.goWrite()
        }).disposed(by: self.disposeBag)
        
        self.currentLocation.subscribe(onNext: { [weak self] location in
            self?.listener?.triggerMeasureDistance(with: CLLocation(latitude: location.latitude,
                                                                    longitude: location.longitude))
        }).disposed(by: self.disposeBag)
        
        self.mapContainerView.mapView.rx.handleViewForAnnotation { mapView, annotation in
            guard let annotation = annotation as? MemoryAnnotation else { return nil }
            let identifier = MKMapViewDefaultClusterAnnotationViewReuseIdentifier
            var view: MemoryAnnotationView
            if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MemoryAnnotationView {
                dequedView.annotation = annotation
                view = dequedView
            } else {
                view = MemoryAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }

            return view
        }
    }
    
    private func setBindReadViewController() {
        self.titleSegment.rx.value.subscribe(onNext: { [weak self] segment in
            if segment == 0 {
                self?.changeMap()
            } else {
                self?.changeList()
            }
        }).disposed(by: self.disposeBag)
    }
}

extension ReadViewController: ReadPresentable {
    func addAnnotations(annotations: [MKAnnotation]) {
        self.mapContainerView.mapView.removeAnnotations(self.mapContainerView.mapView.annotations)
        self.mapContainerView.mapView.addAnnotations(annotations)
    }
}

// MARK: CollectionView
extension ReadViewController {
    private func setupCollectionView() {
        self.dataSource = RxCollectionViewSectionedAnimatedDataSource(configureCell: self.collectionViewDataSourceUI())
        self.gridView.collectionView.contentInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        self.gridView.collectionView.delegate = self
        self.gridView.collectionView.register(PlaceGridCell.self, forCellWithReuseIdentifier: "PlaceGridCell")
    }
    
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 11
        layout.minimumInteritemSpacing = 11
        self.gridView.collectionView.collectionViewLayout = layout
    }
}

// MARK: CollectionView DataSoruce
extension ReadViewController {
    private func collectionViewDataSourceUI() -> CollectionViewSectionedDataSource<SectionOfMemory>.ConfigureCell {
            return collectionViewDataSourceConfigureCell()
    }
    
    private func collectionViewDataSourceConfigureCell() -> CollectionViewSectionedDataSource<SectionOfMemory>.ConfigureCell {
        return { (dataSource, collectionView, indexPath, item) in
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceGridCell", for: indexPath) as? PlaceGridCell {
                cell.content = item
                cell.setupUI()
                return cell
            }

            return UICollectionViewCell()
        }
    }
}

// MARK: CollectionView FlowLayout
extension ReadViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.width / 2 - 24
        return CGSize(width: size, height: 220)
    }
}
