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
    private var searchResult = PublishSubject<SearchPlaceItemViewModel>()
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
        textField.returnKeyType = .done
        return textField
    }()
    
    private var searchImage: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "icSearchActive")
        return imgView
    }()
    
    private var searchResultTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.rowHeight = 46
        tableView.backgroundColor = .white
        tableView.register(SearchPlaceCell.self, forCellReuseIdentifier: "SearchPlaceCell")
        tableView.separatorStyle = .none
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTextField.becomeFirstResponder()
        self.addObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigation()
    }
    
    init(location: BehaviorSubject<CLLocationCoordinate2D>,
         searchResult: PublishSubject<SearchPlaceItemViewModel>) {
        self.currentLocation = location
        self.searchResult = searchResult
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.removeObservers()
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
        output.itemViewModel.drive(self.searchResultTableView.rx.items(cellIdentifier: "SearchPlaceCell", cellType: SearchPlaceCell.self)) {tableView, viewModel, cell in
            cell.bind(viewModel)
        }.disposed(by: self.disposeBag)
        
        self.searchResultTableView.rx.modelSelected(SearchPlaceItemViewModel.self)
            .do(onNext: { _ in self.navigationController?.popViewController(animated: true) })
            .bind(to: self.searchResult)
            .disposed(by: self.disposeBag)
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(onUIKeyboardWillShowNotification(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onUIKeyboardWillHideNotification(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func hideNavigation() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    @objc
    func onUIKeyboardWillShowNotification(noti: Notification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 0.3) {
                self.searchResultTableView.snp.remakeConstraints {
                    $0.top.equalTo(self.searchTextFieldContainer.snp.bottom).offset(15)
                    $0.left.equalToSuperview()
                    $0.right.equalToSuperview()
                    $0.bottom.equalToSuperview().offset(-keyboardHeight)
                }
            }
        }
    }
    
    @objc
    func onUIKeyboardWillHideNotification(noti: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.searchResultTableView.snp.remakeConstraints {
                $0.top.equalTo(self.searchTextFieldContainer.snp.bottom).offset(15)
                $0.left.equalToSuperview()
                $0.right.equalToSuperview()
                $0.bottom.equalTo(self.view.safeArea.bottom)
            }
        }
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
    }
}
