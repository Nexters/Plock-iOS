//
//  RxMKMapViewDelegateProxy.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/09.
//  Copyright © 2019 Zedd. All rights reserved.
//

import MapKit
import RxCocoa

final class RxMKMapViewDelegateProxy: DelegateProxy<MKMapView, MKMapViewDelegate>, DelegateProxyType, MKMapViewDelegate {
    static func registerKnownImplementations() {
        self.register { (mapView) -> RxMKMapViewDelegateProxy in
            RxMKMapViewDelegateProxy(parentObject: mapView, delegateProxy: self)
        }
    }

    static func currentDelegate(for object: MKMapView) -> MKMapViewDelegate? {
        return object.delegate
    }

    static func setCurrentDelegate(_ delegate: MKMapViewDelegate?, to object: MKMapView) {
        object.delegate = delegate
    }
}
