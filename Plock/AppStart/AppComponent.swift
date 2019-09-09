//
//  AppComponent.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/07/29.
//  Copyright © 2019 Zedd. All rights reserved.
//

import Foundation
import RIBs

final class AppComponent: Component<EmptyDependency>, RootDependency {

    init() {
        super.init(dependency: EmptyComponent())
    }
}
