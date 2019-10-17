//
//  _FullScreenModalNavigationController.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/10/10.
//  Copyright © 2019 nexters. All rights reserved.
//

import UIKit

typealias UINavigationController = _FullScreenModalNavigationController
class _FullScreenModalNavigationController: UIKit.UINavigationController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .fullScreen
    }
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.modalPresentationStyle = .fullScreen
    }
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.modalPresentationStyle = .fullScreen
    }
}
