//
//  Rx+.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/10.
//  Copyright © 2019 Zedd. All rights reserved.
//

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
}

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}
