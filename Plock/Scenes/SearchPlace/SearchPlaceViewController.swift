//
//  SearchPlaceViewController.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/16.
//  Copyright © 2019 Zedd. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

import RxSwift
import RxCocoa

final class SearchPlaceViewController: BaseViewController, LocationGettable {

    // MARk: Properties
    private let viewModel = SearchPlaceViewModel()
    private var currentLocation: BehaviorSubject<CLLocationCoordinate2D> = BehaviorSubject(value: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    private lazy var disposeBag = self.viewModel.disposeBag
    
    // MARK: UI Component
    private var searchTextFieldContainer: UIView = {
        let button = UIView()
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.mainBlue().cgColor
        button.layer.cornerRadius = 5
        return button
    }()
    
    private var searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = .bold(size: 16)
        textField.textColor = .grey2()
        return textField
    }()
    
    private var searchImage: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "icSearchActive")
        return imgView
    }()
    
    private var searchResultTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(location: BehaviorSubject<CLLocationCoordinate2D>) {
        self.currentLocation = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        self.title = "위치 설정"
        self.view.backgroundColor = .white
        self.view.addSubview(self.searchTextFieldContainer)
        self.view.addSubview(self.searchTextField)
        self.view.addSubview(self.searchImage)
        self.view.addSubview(self.searchResultTableView)
        
        self.layout()
    }
    
    override func setupBind() {
        let searchText = self.searchTextField.rx.text.orEmpty
        let searchTrigger = searchText.withLatestFrom(self.currentLocation) { ($0, CLLocation(latitude: $1.latitude,
                                                                                            longitude: $1.longitude)) }
        
        let input = SearchPlaceViewModel.Input(searchTrigger: searchTrigger.asDriverOnErrorJustComplete())
        let output = self.viewModel.transform(input: input)
        output.places.drive(onNext: {
            print("search: \($0)")
        }).disposed(by: self.disposeBag)
    }
}

// MARK: UI Layout
extension SearchPlaceViewController {
    private func layout() {
        self.searchTextFieldContainer.snp.makeConstraints {
            $0.top.equalTo(self.view.safeArea.top).offset(8)
            $0.left.equalTo(self.view.safeArea.left).offset(24)
            $0.right.equalTo(self.view.safeArea.right).offset(-24)
            $0.height.equalTo(43)
        }
        
        self.searchImage.snp.makeConstraints {
            $0.centerY.equalTo(self.searchTextFieldContainer)
            $0.left.equalTo(self.searchTextFieldContainer.snp.left).offset(12)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        self.searchTextField.snp.makeConstraints {
            $0.centerY.equalTo(self.searchTextFieldContainer)
            $0.left.equalTo(self.searchImage.snp.right).offset(4)
            $0.right.equalTo(self.searchTextFieldContainer).offset(-10)
        }
        
        self.searchResultTableView.snp.makeConstraints {
            $0.top.equalTo(self.searchTextFieldContainer.snp.bottom).offset(15)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalTo(self.view.safeArea.bottom).offset(5)
        }
    }
}
