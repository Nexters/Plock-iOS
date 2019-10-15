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
    var delegate: RxMKMapViewDelegateProxy {
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
        }).debug("delegateDidUpdate")
    }
    
    var didChangeVisibleRegion: Observable<CLLocationCoordinate2D> {
        return delegate.methodInvoked(#selector(MKMapViewDelegate.mapViewDidChangeVisibleRegion(_:))).map { (parameters) in
            return (parameters[0] as? MKMapView ?? MKMapView()).centerCoordinate
        }
    }
    
    var didTapAnnotationView: Observable<MKAnnotation> {
        return delegate.methodInvoked(#selector(MKMapViewDelegate.mapView(_:annotationView:calloutAccessoryControlTapped:))).map { (parameters) in
            return (parameters[1] as! MKAnnotationView).annotation!
        }
    }
    
    public func handleViewForAnnotation(_ closure: RxMKHandleViewForAnnotaion?) {
        delegate.handleViewForAnnotation = closure
    }
}
