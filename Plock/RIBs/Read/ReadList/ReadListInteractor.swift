//
//  ReadListInteractor.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/03.
//  Copyright © 2019 Zedd. All rights reserved.
//

import RIBs
import RxSwift

protocol ReadListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ReadListPresentable: Presentable {
    var listener: ReadListPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ReadListListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ReadListInteractor: PresentableInteractor<ReadListPresentable>, ReadListInteractable, ReadListPresentableListener {

    weak var router: ReadListRouting?
    weak var listener: ReadListListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ReadListPresentable) {
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
