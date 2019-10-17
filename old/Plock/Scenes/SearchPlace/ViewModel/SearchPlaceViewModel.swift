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

final class SearchPlaceViewModel: ViewModelType, LocationGettable {
    let disposeBag = DisposeBag()
}

extension SearchPlaceViewModel {
    struct Input {
        let searchTrigger: Driver<(String, CLLocation)>
    }
    
    struct Output {
        let itemViewModel: Driver<[SearchPlaceItemViewModel]>
    }
    
    func transform(input: Input) -> Output {
        let search = input.searchTrigger
        let mapItem = PublishSubject<[MKMapItem]>()
        
        search.debounce(0.3).flatMapLatest {
            self.searchPlace(with: $1, keyword: $0)
        }.drive(mapItem)
            .disposed(by: self.disposeBag)
        
        let itemViewModel = mapItem.debug("itemViewModel").filter { !$0.isEmpty }
            .map { $0.map { SearchPlaceItemViewModel(with: $0) }
        }
        
        return Output(itemViewModel: itemViewModel.asDriverOnErrorJustComplete())
    }
}
