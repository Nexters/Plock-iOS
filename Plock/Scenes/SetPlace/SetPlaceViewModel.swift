//
//  SetPlaceViewModel.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/14.
//  Copyright © 2019 Zedd. All rights reserved.
//

import Foundation
import MapKit
import RxCocoa
import RxSwift

final class SetPlaceViewModel {
    private let disposeBag = DisposeBag()
    private let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
}

extension SetPlaceViewModel: ViewModelType {
    struct Input {
        let reverseGeocodeLocationTrigger: Driver<CLLocationCoordinate2D>
    }
    
    struct Output {
        let placeMark: Driver<CLPlacemark>
    }
    
    func transform(input: Input) -> Output {
        let placeTrigger = input.reverseGeocodeLocationTrigger
        let placeMark = placeTrigger.map { CLLocation(latitude: $0.latitude,
                                                     longitude: $0.longitude) }
            .debounce(1)
            .flatMapLatest {
                self.getPlace(location: $0)
        }
        
        return Output(placeMark: placeMark)
    }
}

// MARK: Driver create
extension SetPlaceViewModel {
    private func getPlace(location: CLLocation) -> Driver<CLPlacemark> {
        return Observable.create { emit in
            CLGeocoder().reverseGeocodeLocation(location) { (placeMarks, error) in
                guard error == nil else {
                    print("*** Error in \(#function): \(error!.localizedDescription)")
                    emit.onError(error!)
                    return
                }
                
                guard let placemark = placeMarks?[0] else {
                    print("*** Error in \(#function): placemark is nil")
                    emit.onError(error!)
                    return
                }
                
                emit.onNext(placemark)
                emit.onCompleted()
            }
            return Disposables.create()
        }.asDriverOnErrorJustComplete()
    }
}
