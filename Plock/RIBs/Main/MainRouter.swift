//
//  MainRouter.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/02.
//  Copyright © 2019 Zedd. All rights reserved.
//

import RIBs

protocol MainInteractable: Interactable, ReadListener {
    var router: MainRouting? { get set }
    var listener: MainListener? { get set }
}

protocol MainViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MainRouter: ViewableRouter<MainInteractable, MainViewControllable> {
    private let readBuilder: ReadBuildable
    private var readRouter: ViewableRouting?
    private weak var currentChild: ViewableRouting?
    
    init(interactor: MainInteractable,
         viewController: MainViewControllable,
         readBuilder: ReadBuilder) {
        self.readBuilder = readBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension MainRouter: MainRouting {
    func goRead() {
        let router = self.readBuilder.build(withListener: self.interactor)
        self.currentChild = router
        attachChild(router)
        self.viewController.uiviewController.navigationController?.pushViewController(router.viewControllable.uiviewController,
                                                                                      animated: true)
        self.readRouter = router
    }
    
    func goWrite() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let makePlaceViewController = storyboard.instantiateViewController(withIdentifier: "MakePlaceViewController")
        self.viewController.uiviewController.navigationController?.pushViewController(makePlaceViewController, animated: true)
    }
    
    private func detachDetail() {
        if let currentChild = self.currentChild {
            detachChild(currentChild)
        }
    }
}
