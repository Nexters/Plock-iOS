//
//  ReadInteractor.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/03.
//  Copyright © 2019 Zedd. All rights reserved.
//

import RIBs
import MapKit

import RxSwift
import RxCocoa

protocol ReadRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func goWrite()
}

protocol ReadPresentable: Presentable {
    var listener: ReadPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func addAnnotations(annotations: [MKAnnotation])
    var triggerDrawCollectionView: PublishSubject<[SectionOfMemory]> { get }
}

protocol ReadListener: class {
}

final class ReadInteractor: PresentableInteractor<ReadPresentable>, ReadInteractable {

    private let memories = PublishSubject<[Memory]>()
    private let currentLocation = PublishSubject<CLLocation>()
    private let triggerMemories = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private let allowableDistance = 100.0
    weak var router: ReadRouting?
    weak var listener: ReadListener?
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ReadPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
        self.setBind()
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func setBind() {
        self.triggerMemories
            .flatMapLatest { self.rxFetchObservable() }
            .asDriverOnErrorJustComplete()
            .drive(self.memories)
            .disposed(by: self.disposeBag)

        let convertMemories = Observable.combineLatest(self.memories, self.currentLocation) { ($0, $1) }
        convertMemories.subscribe(onNext: { [weak self] (memories, currentLocation) in
            let memories = memories.map {
                MemoryAnnotation(with: $0)
            }
            
            let newAnnotations = ContestedAnnotationTool.annotationsByDistributingAnnotations(annotations: memories) { (oldAnnotation: MemoryAnnotation, newCoordinate: CLLocationCoordinate2D) in
                let differ = currentLocation.distance(from: CLLocation(latitude: oldAnnotation.coordinate.latitude, longitude: oldAnnotation.coordinate.longitude))
                
                var isLock = true
                if differ < self?.allowableDistance ?? 0.0 {
                    isLock = false
                }
                
                return MemoryAnnotation(coordinate: newCoordinate,
                                 image: oldAnnotation.image,
                                 isLock: isLock)
            }
            
            self?.presenter.addAnnotations(annotations: newAnnotations)
        }).disposed(by: self.disposeBag)
        
        convertMemories
            .debounce(1, scheduler: MainScheduler.instance)
            .map { (memories, currentLocation) in
                memories.map { self.convertMemoryPlace(currentLocation: currentLocation, memory: $0) } }
            .map { (memories)  in
                let random = Int(Date().timeIntervalSince1970) + Int(arc4random())
                let sorted = memories.sorted(by: { !$0.isLock && $1.isLock })
                return [SectionOfMemory(header: random, items: sorted)]
        }
        .bind(to: self.presenter.triggerDrawCollectionView)
        .disposed(by: self.disposeBag)
    }
}

extension ReadInteractor: ReadPresentableListener {
    func triggerFetchMemories() {
        self.triggerMemories.onNext(())
    }
    
    func triggerMeasureDistance(with currentLocation: CLLocation) {
        self.currentLocation.onNext(currentLocation)
    }
    
    func goWrite() {
        self.router?.goWrite()
    }
}

extension ReadInteractor {
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
    
    private func convertMemoryPlace(currentLocation: CLLocation,
                                    memory: Memory) -> MemoryPlace {
        let differ = currentLocation.distance(from: CLLocation(latitude: memory.latitude, longitude: memory.longitude))
        var isLock = true
        
        if differ < self.allowableDistance {
            isLock = false
        }
        
        return MemoryPlace(title: memory.title ?? "",
                           address: memory.address ?? "",
                           content: memory.content ?? "",
                           date: memory.date ?? Date(),
                           latitude: memory.latitude ,
                           longitude: memory.latitude ,
                           image: memory.image ?? Data(),
                           id: Int(memory.id ),
                           isLock: isLock
        )
    }
}
