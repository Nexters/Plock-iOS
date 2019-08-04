//
//  ReadMapViewController.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/03.
//  Copyright © 2019 Zedd. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol ReadMapPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class ReadMapViewController: UIViewController, ReadMapPresentable, ReadMapViewControllable {

    weak var listener: ReadMapPresentableListener?
}
