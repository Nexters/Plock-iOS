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
    let disposeBag = DisposeBag()
}

extension SetPlaceViewModel: ViewModelType, LocationGettable {
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
            .flatMapLatest {
                self.replacePlaceMark(with: $0)
        }
        
        return Output(placeMark: placeMark)
    }
}
