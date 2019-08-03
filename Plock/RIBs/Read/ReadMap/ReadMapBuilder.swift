//
//  ReadMapBuilder.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/03.
//  Copyright © 2019 Zedd. All rights reserved.
//

import RIBs

protocol ReadMapDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ReadMapComponent: Component<ReadMapDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ReadMapBuildable: Buildable {
    func build(withListener listener: ReadMapListener) -> ReadMapRouting
}

final class ReadMapBuilder: Builder<ReadMapDependency>, ReadMapBuildable {

    override init(dependency: ReadMapDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ReadMapListener) -> ReadMapRouting {
        let component = ReadMapComponent(dependency: dependency)
        let viewController = ReadMapViewController()
        let interactor = ReadMapInteractor(presenter: viewController)
        interactor.listener = listener
        return ReadMapRouter(interactor: interactor, viewController: viewController)
    }
}
