//
//  RootRouter.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/07/29.
//  Copyright © 2019 Zedd. All rights reserved.
//

import RIBs


protocol RootInteractable: Interactable, MainListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    func present(viewController:ViewControllable)
    func dismiss(viewController:ViewControllable)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {
    private var mainBuilder: MainBuildable
    
    
    init(interactor: RootInteractable,
         viewController: RootViewControllable,
         mainBuilder: MainBuildable) {
        self.mainBuilder = mainBuilder
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
        let mainBuilder = self.mainBuilder.build(withListener: self.interactor)
        self.attachChild(mainBuilder)
        self.viewController.present(viewController: mainBuilder.viewControllable)
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//        self.viewController.present(viewController: viewController)
    }
}


