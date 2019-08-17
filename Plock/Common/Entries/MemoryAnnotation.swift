//
//  MemoryPlace.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/17.
//  Copyright © 2019 Zedd. All rights reserved.
//

import Foundation
import MapKit

final class MemoryAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var image: UIImage
    
    init(coordinate: CLLocationCoordinate2D,
         image: UIImage) {
        self.coordinate = coordinate
        self.image = image
        super.init()
    }
    
    init(with memory: Memory) {
        self.coordinate = CLLocationCoordinate2D(latitude: memory.latitude, longitude: memory.longitude)
        self.image = UIImage(data: memory.image ?? Data()) ?? UIImage()
    }
}
