//
//  ReadMapRouter.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/03.
//  Copyright © 2019 Zedd. All rights reserved.
//

import RIBs

protocol ReadMapInteractable: Interactable {
    var router: ReadMapRouting? { get set }
    var listener: ReadMapListener? { get set }
}

protocol ReadMapViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ReadMapRouter: ViewableRouter<ReadMapInteractable, ReadMapViewControllable>, ReadMapRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ReadMapInteractable, viewController: ReadMapViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
