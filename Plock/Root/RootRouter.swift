//
//  RootRouter.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/07/29.
//  Copyright © 2019 Zedd. All rights reserved.
//

import RIBs


protocol RootInteractable: Interactable {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    func present(viewController:ViewControllable)
    func dismiss(viewController:ViewControllable)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RootInteractable,
                  viewController: RootViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        self.routeToViewController()
    }
}


// MARK: - Private
extension RootRouter{
    private func routeToViewController(){
//        let loggedOut = loggedOutBuilder.build(withListener: interactor)
//        self.loggedOut = loggedOut
//        attachChild(loggedOut)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.viewController.present(viewController: viewController)
    }
}


