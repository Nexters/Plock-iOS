//
//  SetPlaceViewController.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/13.
//  Copyright © 2019 Zedd. All rights reserved.
//

import UIKit
import RIBs

extension SetPlaceViewController: ViewControllable { }
class SetPlaceViewController: BaseViewController {
    
    private lazy var mapContainerView = MapContainerView(controlBy: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.mapContainerView
    }
}
