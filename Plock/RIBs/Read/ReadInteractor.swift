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
}

protocol ReadPresentable: Presentable {
    var listener: ReadPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func addAnnotations(annotations: [MKAnnotation])
}

protocol ReadListener: class {
}

final class ReadInteractor: PresentableInteractor<ReadPresentable>, ReadInteractable {

    private let memories = PublishSubject<[Memory]>()
    private let triggerMemories = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
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
        self.memories.subscribe(onNext: { [weak self] memory in
            let memories = memory.map {
                MemoryAnnotation(with: $0)
            }
            
            let newAnnotations = ContestedAnnotationTool.annotationsByDistributingAnnotations(annotations: memories) { (oldAnnotation: MemoryAnnotation, newCoordinate: CLLocationCoordinate2D) in
                MemoryAnnotation(coordinate: newCoordinate, image: oldAnnotation.image)
            }
            
            self?.presenter.addAnnotations(annotations: newAnnotations)
        }).disposed(by: self.disposeBag)
        
        self.triggerMemories.debug("triggerMemories").flatMapLatest {
            self.rxFetchObservable()
        }.asDriverOnErrorJustComplete()
            .drive(self.memories).disposed(by: self.disposeBag)
    }
}

extension ReadInteractor: ReadPresentableListener {
    func triggerFetchMemories() {
        self.triggerMemories.onNext(())
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
}
