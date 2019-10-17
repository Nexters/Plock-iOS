//
//  Rx+.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/10.
//  Copyright © 2019 Zedd. All rights reserved.
//
import Foundation
import RxCocoa
import RxSwift

extension ObservableType {
    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { error in
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
    func unwrap<T>() -> Observable<T> where E == T? {
        return self.filter { $0 != nil }.map {$0!}
    }
}

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
    
    func unwrap<T>() -> SharedSequence<SharingStrategy,T> where E == T? {
        return self.filter { $0 != nil }.map { $0! }
    }
}

extension Reactive where Base: UIViewController {
    var viewDidload: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { _ in }
        return ControlEvent(events: source)
    }
}
