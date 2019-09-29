//
//  ReadViewModel.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/09/29.
//  Copyright © 2019 nexters. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit

final class ReadViewModel: ViewModelType {
    private let allowableDistance = 100.0
    let disposeBag = DisposeBag()
}

extension ReadViewModel {
    struct Input {
        let triggerMemoryFetch: Driver<Void>
        let triggerMeasureDistance: Driver<CLLocation>
    }
    
    struct Output {
        let memoryAnnotation: Driver<[MemoryAnnotation]>
        let sectionOfMemories : Driver<[SectionOfMemory]>
    }
    
    func transform(input: Input) -> Output {
        let memories = PublishSubject<[Memory]>()
        input.triggerMemoryFetch
            .flatMapLatest { [weak self] _ in self!.rxFetchObservable() }
            .drive(memories)
            .disposed(by: self.disposeBag)
        
        let convertMemories = Observable.combineLatest(memories, input.triggerMeasureDistance.asObservable()) { ($0, $1) }
        let memoryAnnotation = convertMemories.map{ [weak self] in
            self?.makeMemoryAnnotation(memories: $0, currentLocation: $1)
        }.unwrap()
        
        let sectionOfMemories = convertMemories
            .debounce(1, scheduler: MainScheduler.instance)
            .map { [weak self] (memories, currentLocation) in
                memories.map { self?.convertMemoryPlace(currentLocation: currentLocation, memory: $0) } }
            .map { (memories)  -> [SectionOfMemory] in
                let random = Int(Date().timeIntervalSince1970) + Int(arc4random())
                let sorted = memories.sorted(by: { !$0!.isLock && $1!.isLock })
                return [SectionOfMemory(header: random, items: sorted as! [MemoryPlace])]
        }
        
        return Output(memoryAnnotation: memoryAnnotation.asDriverOnErrorJustComplete(),
                      sectionOfMemories: sectionOfMemories.asDriverOnErrorJustComplete())
    }
}


extension ReadViewModel {
    private func makeMemoryAnnotation(memories: [Memory], currentLocation: CLLocation) -> [MemoryAnnotation] {
        let memories = memories.map {
            MemoryAnnotation(with: $0)
        }
        
        let newAnnotations = ContestedAnnotationTool.annotationsByDistributingAnnotations(annotations: memories) { (oldAnnotation: MemoryAnnotation, newCoordinate: CLLocationCoordinate2D) in
            let differ = currentLocation.distance(from: CLLocation(latitude: oldAnnotation.coordinate.latitude, longitude: oldAnnotation.coordinate.longitude))
            
            var isLock = true
            if differ < self.allowableDistance {
                isLock = false
            }
            
            return MemoryAnnotation(coordinate: newCoordinate,
                                    image: oldAnnotation.image,
                                    isLock: isLock,
                                    id: oldAnnotation.id)
        }
        
        return newAnnotations
    }
    private func rxFetchObservable() -> Driver<[Memory]> {
        return Observable.create { emit in
            let memories = CoreDataHandler.fetchObject()
            guard let memory = memories else {
                emit.onError(NSError(domain: "", code: 400, userInfo: nil))
                return Disposables.create()
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
