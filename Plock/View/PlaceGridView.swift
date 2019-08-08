//
//  PlaceGridView.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/07.
//  Copyright © 2019 Zedd. All rights reserved.
//

import UIKit

final class PlaceGridView: BaseView{
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .white
        return cv
    }()
    
    override func setupUI() {
        self.backgroundColor = .white
        self.addSubview(self.collectionView)
        self.layout()
    }
    
    override func setupBind() {
        
    }
    
    private func layout() {
        self.collectionView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
