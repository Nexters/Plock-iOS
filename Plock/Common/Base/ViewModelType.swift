//
//  ViewModelType.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/14.
//  Copyright © 2019 Zedd. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
