//
//  HomeView.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/09/29.
//  Copyright © 2019 nexters. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

final class HomeView: BaseView {
    lazy var touchedWriteButton: Driver<Void> = self.writeButton.rx.tap.asDriver()
    lazy var touchedReadButton: Driver<Void> = self.readButton.rx.tap.asDriver()
    
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
    
    override func setupUI() {
        self.backgroundColor = .white
        self.addSubview(self.buttonStackView)
        self.addSubview(self.logoImageView)
        self.addSubview(self.logoWordImageView)
        
        self.buildButtons()
        self.layout()
    }
    
    override func setupBind() {
        
    }
}

extension HomeView {
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
