//
//  ReadMapInteractor.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/03.
//  Copyright © 2019 Zedd. All rights reserved.
//

import RIBs
import RxSwift

protocol ReadMapRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ReadMapPresentable: Presentable {
    var listener: ReadMapPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ReadMapListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ReadMapInteractor: PresentableInteractor<ReadMapPresentable>, ReadMapInteractable, ReadMapPresentableListener {

    weak var router: ReadMapRouting?
    weak var listener: ReadMapListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ReadMapPresentable) {
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
