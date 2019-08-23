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
    var isLock = false
    var id: Int
    
    init(coordinate: CLLocationCoordinate2D,
         image: UIImage,
         isLock: Bool,
         id: Int) {
        self.coordinate = coordinate
        self.image = image
        self.isLock = isLock
        self.id = id
        super.init()
    }
    
    init(with memory: Memory) {
        self.coordinate = CLLocationCoordinate2D(latitude: memory.latitude, longitude: memory.longitude)
        self.image = UIImage(data: memory.image ?? Data()) ?? UIImage()
        self.id = Int(memory.id)
    }
}
