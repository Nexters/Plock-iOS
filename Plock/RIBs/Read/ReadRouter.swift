//
//  ReadRouter.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/03.
//  Copyright © 2019 Zedd. All rights reserved.
//

import RIBs

protocol ReadInteractable: Interactable {
    var router: ReadRouting? { get set }
    var listener: ReadListener? { get set }
}

protocol ReadViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ReadRouter: ViewableRouter<ReadInteractable, ReadViewControllable>, ReadRouting {
    private weak var currentChild: ViewableRouting?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ReadInteractable,
                  viewController: ReadViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func goWrite() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let makePlaceViewController = storyboard.instantiateViewController(withIdentifier: "MakePlaceViewController")
        self.viewController.uiviewController.navigationController?.pushViewController(makePlaceViewController, animated: true)
    }
}
