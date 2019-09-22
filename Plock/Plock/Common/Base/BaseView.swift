//
//  BaseView.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/03.
//  Copyright © 2019 Zedd. All rights reserved.
//

import UIKit

class BaseView: UIView {
    // MARK: Properties
    weak var vc: BaseViewController!
    
    // MARK: Initialize
    init() {
        super.init(frame: UIScreen.main.bounds)
        self.setupUI()
        self.setupBind()
    }
    
    required init(controlBy viewController: BaseViewController) {
        self.vc = viewController
        super.init(frame: UIScreen.main.bounds)
        self.setupUI()
        self.setupBind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        //Override
    }
    
    func setupBind() {
        //Override
    }

    deinit {
        
    }
}
