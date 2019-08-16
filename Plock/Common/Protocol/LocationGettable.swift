//
//  LocationGettable.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/16.
//  Copyright © 2019 Zedd. All rights reserved.
//

import Foundation
import MapKit
import RxSwift
import RxCocoa

protocol LocationGettable {
    func replacePlaceMark(with location: CLLocation) -> Driver<CLPlacemark>
    func searchPlace(with location: CLLocation, keyword: String) -> Driver<[MKMapItem]>
}

extension LocationGettable {
    func replacePlaceMark(with location: CLLocation) -> Driver<CLPlacemark> {
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

    func searchPlace(with location: CLLocation, keyword: String) -> Driver<[MKMapItem]> {
        return Observable.create { emit in
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = keyword
            request.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            let search = MKLocalSearch(request: request)
            search.start { (response, _) in
                guard let response = response else { return }
                print("search List : \(response)")
                emit.onNext(response.mapItems)
                emit.onCompleted()
            }
            
            return Disposables.create()
        }.asDriverOnErrorJustComplete()
    }
}
