//
//  MainViewController.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/02.
//  Copyright © 2019 Zedd. All rights reserved.
//

import RIBs
import RxCocoa
import RxSwift
import SnapKit
import UIKit

protocol MainPresentableListener: class {
    func read()
    func write()
}

final class MainViewController: BaseViewController, MainPresentable, MainViewControllable, SettableUINavigationBar {
    
    // MARK: Property
    private let disposeBag = DisposeBag()
    weak var listener: MainPresentableListener?
    
    // MARK: UI Component
    private var writeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "writeButton"), for: .normal)
        return button
    }()
    
    private var readButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "readButton"), for: .normal)
        return button
    }()
    
    private var writeLabel: UILabel = {
        let label = UILabel()
        label.text = "카드기록"
        return label
    }()
    
    private var readLabel: UILabel = {
        let label = UILabel()
        label.text = "열람하기"
        return label
    }()
    
    private var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "plockPicture")
        return imageView
    }()
    
    private var logoWordImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "plockWord")
        return imgView
    }()
    
    private var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment    = .leading
        stackView.spacing = 50
        return stackView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.showNavigation()
    }
    
    override func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.buttonStackView)
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.logoWordImageView)
        
        self.buildButtons()
        self.layout()
    }
    
    override func setupBind() {
        self.writeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.listener?.write()
            }).disposed(by: self.disposeBag)
        
        self.readButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.listener?.read()
            }).disposed(by: self.disposeBag)
    }
}

// MARK: draw UI
extension MainViewController {
    private func buildButtons() {
        let writeStackView = UIStackView()
        writeStackView.axis = .vertical
        writeStackView.distribution = .equalSpacing
        writeStackView.spacing = 5
        writeStackView.addArrangedSubview(self.writeButton)
        writeStackView.addArrangedSubview(self.writeLabel)
        
        let readStackView = UIStackView()
        readStackView.axis = .vertical
        readStackView.distribution = .equalSpacing
        readStackView.spacing = 5
        readStackView.addArrangedSubview(self.readButton)
        readStackView.addArrangedSubview(self.readLabel)
        
        let lineView = UIView()
        lineView.backgroundColor = .lightGray
        lineView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(76)
        }
        
        self.buttonStackView.addArrangedSubview(writeStackView)
        self.buttonStackView.addArrangedSubview(lineView)
        self.buttonStackView.addArrangedSubview(readStackView)
        
    }
    
    private func layout() {
        self.logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
            $0.width.equalTo(233)
            $0.height.equalTo(207)
        }
        
        self.logoWordImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.logoImageView.snp.bottom).offset(14)
            $0.width.equalTo(168)
            $0.height.equalTo(52)
        }
        
        self.buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.logoWordImageView.snp.bottom).offset(60)
        }
    }
}
