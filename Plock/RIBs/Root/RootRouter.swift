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

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable> {
    private var mainBuilder: MainBuildable
    private var mainRouting: ViewableRouting?
    private var readRouting: ViewableRouting?
    
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
extension RootRouter: RootRouting{
    func routeToWrite() {
        print("routeToWrite")
        /*
         제드꺼 붙이면 됨
         */
        if let main = self.mainRouting {
            self.detachChild(main)
            viewController.dismiss(viewController: main.viewControllable)
            self.mainRouting = nil
        }
        let vc = ViewController()
        self.viewController.present(viewController: vc)
    }
    
    //MARK: Private
    private func routeToViewController(){
        let mainBuilder = self.mainBuilder.build(withListener: self.interactor)
        self.mainRouting = mainBuilder
        self.attachChild(mainBuilder)
        let navigationController = UINavigationController(rootViewController: mainBuilder.viewControllable.uiviewController)
        self.viewController.present(viewController: navigationController)
    }
}


