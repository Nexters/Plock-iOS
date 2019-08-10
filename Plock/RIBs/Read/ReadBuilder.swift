//
//  ReadBuilder.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/03.
//  Copyright © 2019 Zedd. All rights reserved.
//

import RIBs

protocol ReadDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ReadComponent: Component<ReadDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ReadBuildable: Buildable {
    func build(withListener listener: ReadListener) -> ReadRouting
}

final class ReadBuilder: Builder<ReadDependency>, ReadBuildable {

    override init(dependency: ReadDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ReadListener) -> ReadRouting {
        _ = ReadComponent(dependency: dependency)
        let viewController = ReadViewController()
        let interactor = ReadInteractor(presenter: viewController)
        interactor.listener = listener
        
        return ReadRouter(interactor: interactor, viewController: viewController)
    }
}
