//
//  ReadListRouter.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/03.
//  Copyright © 2019 Zedd. All rights reserved.
//

import RIBs

protocol ReadListInteractable: Interactable {
    var router: ReadListRouting? { get set }
    var listener: ReadListListener? { get set }
}

protocol ReadListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ReadListRouter: ViewableRouter<ReadListInteractable, ReadListViewControllable>, ReadListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ReadListInteractable, viewController: ReadListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
