//
//  ViewController.swift
//  Plock
//
//  Created by Zedd on 13/07/2019.
//  Copyright © 2019 Zedd. All rights reserved.
//

import UIKit
import RIBs
import SnapKit

extension ViewController: ViewControllable { }

final class ViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let tempLabel = UILabel()
        tempLabel.text = "하윙"
        self.view.addSubview(tempLabel)
        
        tempLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
