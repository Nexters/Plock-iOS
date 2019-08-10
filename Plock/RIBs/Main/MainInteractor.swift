//
//  MainInteractor.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/02.
//  Copyright © 2019 Zedd. All rights reserved.
//

import RIBs
import RxSwift

protocol MainRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func goRead()
}

protocol MainPresentable: Presentable {
    var listener: MainPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MainListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func goWrite()
}

final class MainInteractor: PresentableInteractor<MainPresentable>, MainInteractable {
    weak var router: MainRouting?
    weak var listener: MainListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: MainPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}

extension MainInteractor: MainPresentableListener {
    func read() {
        self.router?.goRead()
    }
    
    func write() {
        self.listener?.goWrite()
    }
}
