//
//  Rx+.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/09.
//  Copyright © 2019 Zedd. All rights reserved.
//

import MapKit
import RxSwift
import RxCocoa

extension Reactive where Base: MKMapView {
    var delegate: DelegateProxy<MKMapView, MKMapViewDelegate> {
        return RxMKMapViewDelegateProxy.proxy(for: self.base)
    }
    
    var regionDidChangeAnimated: Observable<Bool> {
        return delegate.methodInvoked(#selector(MKMapViewDelegate.mapView(_:regionDidChangeAnimated:)))
            .map({ (parameters) in
                return parameters[1] as? Bool ?? false
            })
    }
    
    var didUpdate: Observable<CLLocationCoordinate2D> {
        return delegate.methodInvoked(#selector(MKMapViewDelegate.mapView(_:didUpdate:))).map({ (parameters) in
            return (parameters[1] as? MKUserLocation)?.coordinate ?? CLLocationCoordinate2D.init(latitude: 0, longitude: 0)
        })
    }
}
