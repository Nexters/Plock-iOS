//
//  MainBuilder.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/02.
//  Copyright © 2019 Zedd. All rights reserved.
//

import RIBs

protocol MainDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MainComponent: Component<MainDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol MainBuildable: Buildable {
    func build(withListener listener: MainListener) -> MainRouting
}

final class MainBuilder: Builder<MainDependency>, MainBuildable {

    override init(dependency: MainDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MainListener) -> MainRouting {
        let component = MainComponent(dependency: dependency)
        let viewController = MainViewController()
        let interactor = MainInteractor(presenter: viewController)
        interactor.listener = listener
        let readBuilder = ReadBuilder(dependency: component)
        
        return MainRouter(interactor: interactor,
                          viewController: viewController,
                          readBuilder: readBuilder)
    }
}
