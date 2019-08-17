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

final class MainViewController: BaseViewController, MainPresentable, MainViewControllable {
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
    
    private func testCode() {
//        let memory = MemoryPlace()
//        memory.title = "제목입니다"
//        memory.content = "오늘은 해가 떴다 핳하"
//        memory.date = Date()
//        memory.image = UIImage(named: "plockPicture")!.pngData()!
//        memory.latitude = 37.497921
//        memory.longitude = 127.027685
//        CoreDataHandler.saveObject(memory: memory)
        
        let memory2 = MemoryPlace()
        memory2.title = "제목2"
        memory2.content = "오늘은 비가 온다 핳하"
        memory2.date = Date()
        memory2.image = UIImage(named: "plockPicture")!.pngData()!
        memory2.latitude = 37.497214
        memory2.longitude = 127.026226
        CoreDataHandler.saveObject(memory: memory2)
    }
}

// MARK: draw UI
extension MainViewController {
    private func hideNavigation() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    private func showNavigation() {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
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
            $0.top.equalToSuperview().offset(112)
            $0.width.equalTo(233)
            $0.height.equalTo(207)
        }
        
        self.buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.view.safeArea.bottom).offset(-80)
        }
        
        self.logoWordImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.logoImageView.snp.bottom).offset(14)
            $0.width.equalTo(168)
            $0.height.equalTo(52)
        }
    }
}
