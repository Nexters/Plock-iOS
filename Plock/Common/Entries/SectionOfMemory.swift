//
//  SectionOfMemories.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/20.
//  Copyright © 2019 Zedd. All rights reserved.
//

import Foundation
import RxDataSources

struct SectionOfMemory {
    var header: Int
    var items: [MemoryPlace]
}

extension SectionOfMemory: AnimatableSectionModelType {
    typealias Identity = Int
    typealias Item     = MemoryPlace
    
    var identity: Int{
        return header
    }
    
    init(original: SectionOfMemory, items: [Item]) {
        self = original
        self.items = items
    }
}

extension MemoryPlace: IdentifiableType, Equatable {
    public typealias Identity = Int
    public var identity: Int {
        return self.id
    }
    
    static func == (lhs: MemoryPlace, rhs: MemoryPlace) -> Bool {
        return lhs.address == rhs.address && lhs.content == rhs.content
    }
}
