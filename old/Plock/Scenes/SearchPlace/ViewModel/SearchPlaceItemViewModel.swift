//
//  SearchPlaceItemViewModel.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/17.
//  Copyright © 2019 Zedd. All rights reserved.
//

import Foundation
import MapKit

final class SearchPlaceItemViewModel {
    let title: String
    let subTitle: String
    let coordinate: CLLocationCoordinate2D
    
    init(with item: MKMapItem) {
        self.title = item.placemark.name ?? ""
        self.subTitle = "\(item.placemark.administrativeArea ?? "") \(item.placemark.locality ?? "") \(item.placemark.subLocality ?? "") \(item.placemark.subThoroughfare ?? "") \(item.placemark.postalCode ?? "")"
        self.coordinate = item.placemark.coordinate
    }
    
    init(with placemark: CLPlacemark) {
        self.title = placemark.name ?? ""
        self.subTitle = "\(placemark.administrativeArea ?? "") \(placemark.locality ?? "") \(placemark.subLocality ?? "") \(placemark.subThoroughfare ?? "") \(placemark.postalCode ?? "")"
        self.coordinate = placemark.location?.coordinate ?? CLLocationCoordinate2D()
    }
}
