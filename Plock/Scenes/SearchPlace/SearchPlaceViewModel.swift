//
//  SearchPlaceViewModel.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/16.
//  Copyright © 2019 Zedd. All rights reserved.
//

import Foundation
import MapKit
import RxSwift
import RxCocoa

final class SearchPlaceViewModel: ViewModelType, LocationGettable{
    let disposeBag = DisposeBag()
}

extension SearchPlaceViewModel{
    struct Input {
        let searchTrigger: Driver<(String,CLLocation)>
    }
    
    struct Output {
        let places: Driver<[MKMapItem]>
    }
    
    func transform(input: Input) -> Output {
        let search = input.searchTrigger
        let places = search.debounce(0.3).flatMapLatest{
            self.searchPlace(with: $1, keyword: $0)
        }
        
        return Output(places: places)
    }
}
