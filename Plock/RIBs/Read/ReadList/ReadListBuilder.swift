//
//  ReadListBuilder.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/03.
//  Copyright © 2019 Zedd. All rights reserved.
//

import RIBs

protocol ReadListDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ReadListComponent: Component<ReadListDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ReadListBuildable: Buildable {
    func build(withListener listener: ReadListListener) -> ReadListRouting
}

final class ReadListBuilder: Builder<ReadListDependency>, ReadListBuildable {

    override init(dependency: ReadListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ReadListListener) -> ReadListRouting {
        let component = ReadListComponent(dependency: dependency)
        let viewController = ReadListViewController()
        let interactor = ReadListInteractor(presenter: viewController)
        interactor.listener = listener
        return ReadListRouter(interactor: interactor, viewController: viewController)
    }
}
