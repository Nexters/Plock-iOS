//
//  HomeViewController.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/09/29.
//  Copyright © 2019 nexters. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: BaseViewController, SettableUINavigationBar {
    private let homeView = HomeView()
    private let disposeBag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupBind() {
        self.homeView.touchedReadButton
            .drive(onNext:{ [weak self] in
                self?.goRead()
            }).disposed(by: self.disposeBag)
        
        self.homeView.touchedWriteButton
            .drive(onNext:{ [weak self] in
                self?.goWrite()
            }).disposed(by: self.disposeBag)
    }
}

extension HomeViewController {
    private func goWrite() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let makePlaceViewController = storyboard.instantiateViewController(withIdentifier: "MakePlaceViewController")
        self.navigationController?.pushViewController(makePlaceViewController, animated: true)
    }
    
    private func goRead() {
        self.navigationController?.pushViewController(ReadViewController(), animated: true)
    }
}

// MARK: ViewController Life Cycle
extension HomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        self.view = self.homeView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.showNavigation()
    }
}
