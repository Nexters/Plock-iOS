//
//  SettableUINavigationBar.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/23.
//  Copyright © 2019 Zedd. All rights reserved.
//

import UIKit

protocol SettableUINavigationBar where Self: UIViewController {
    func showNavigation()
    func hideNavigation()
    func setupBackButton()
}

extension SettableUINavigationBar {
    func hideNavigation() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func showNavigation() {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func setupBackButton() {
        self.navigationController?.navigationBar.tintColor = .charcoalGrey()
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backOff")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backOff")
    }
}
