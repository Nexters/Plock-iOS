//
//  ReadInteractor.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/03.
//  Copyright © 2019 Zedd. All rights reserved.
//

import RIBs
import RxSwift

protocol ReadRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ReadPresentable: Presentable {
    var listener: ReadPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ReadListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ReadInteractor: PresentableInteractor<ReadPresentable>, ReadInteractable, ReadPresentableListener {

    weak var router: ReadRouting?
    weak var listener: ReadListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ReadPresentable) {
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
