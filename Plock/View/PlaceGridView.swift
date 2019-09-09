//
//  PlaceGridView.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/07.
//  Copyright © 2019 Zedd. All rights reserved.
//

import UIKit

final class PlaceGridView: BaseView {
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .white
        return cv
    }()
    
    private let emptyDescView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyList")
        return imageView
    }()
    
    private let emptyDescLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 기록된 카드가 없어요..."
        label.font = .bold(size: 18)
        label.textColor = .grey3()
        return label
    }()
    
    override func setupUI() {
        self.backgroundColor = .white
        self.addSubview(self.collectionView)
        self.addSubview(self.emptyDescView)
        self.addSubview(self.emptyDescLabel)
        
        self.layout()
    }
    
    override func setupBind() {
        
    }
    
    private func layout() {
        self.collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        self.emptyDescView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-21)
        }
        
        self.emptyDescLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.emptyDescView.snp.bottom).offset(8)
        }
    }
    
    func showEmptyView() {
        self.emptyDescLabel.isHidden = false
        self.emptyDescView.isHidden = false
    }
    
    func hideEmptyView() {
        self.emptyDescLabel.isHidden = true
        self.emptyDescView.isHidden = true
    }
}
