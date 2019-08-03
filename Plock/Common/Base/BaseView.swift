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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        //Override
    }

    deinit {
        
    }
}
