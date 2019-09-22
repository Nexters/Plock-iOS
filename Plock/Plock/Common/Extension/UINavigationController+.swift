//
//  UINavigationController+.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/03.
//  Copyright © 2019 Zedd. All rights reserved.
//

import RIBs
import UIKit

extension UINavigationController: ViewControllable {

    public var uiviewController: UIViewController { return self }

    public convenience init(viewControllable: ViewControllable) {
        self.init(rootViewController: viewControllable.uiviewController)
    }
}
