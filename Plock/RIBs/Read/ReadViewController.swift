//
//  ReadViewController.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/03.
//  Copyright © 2019 Zedd. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa
import UIKit

protocol ReadPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class ReadViewController: BaseViewController, ReadPresentable, ReadViewControllable {

    weak var listener: ReadPresentableListener?
    private var mapView = MapView()
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView(){
        super.loadView()
        self.view = self.mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        self.view.backgroundColor = .white
        self.setupNavigationTitle()
    }
    
    override func setupBind() {
        
    }
}

//MARK: Draw UI
extension ReadViewController{
    private func setupNavigationTitle(){
        let segment: UISegmentedControl = UISegmentedControl(items: ["지도", "리스트"])
        segment.sizeToFit()
        segment.selectedSegmentIndex = 0;
        self.navigationItem.titleView = segment
        
        segment.rx.value.subscribe(onNext:{
            print("changed segmentControl \($0)")
        }).disposed(by: self.disposeBag)
    }
}
