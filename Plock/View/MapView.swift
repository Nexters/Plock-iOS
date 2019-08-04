//
//  MapView.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/03.
//  Copyright © 2019 Zedd. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import MapKit

final class MapView: BaseView{
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
    
    override func setupUI() {
        self.addSubview(self.mapView)
        self.layout()
    }
}


//MARK: draw UI
extension MapView{
    func layout(){
        self.mapView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
