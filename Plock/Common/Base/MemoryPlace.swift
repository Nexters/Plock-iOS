//
//  MemoryPlace.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/09/10.
//  Copyright © 2019 Zedd. All rights reserved.
//

import Foundation

final class MemoryPlace {
    var title: String
    var address: String
    var content: String
    var date: Date
    var latitude: Double
    var longitude: Double
    var image: Data
    var id: Int
    var isLock: Bool
    
    init(title: String = "",
         address: String = "",
         content: String = "",
         date: Date = Date(),
         latitude: Double = 0.0,
         longitude: Double = 0.0,
         image: Data = Data(),
         id: Int = Int(Date().timeIntervalSince1970) + Int(arc4random()),
         isLock: Bool = false) {
        self.title = title
        self.address = address
        self.content = content
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
        self.image = image
        self.id = id
        self.isLock = isLock
    }
}
