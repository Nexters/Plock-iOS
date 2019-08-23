//
//  PlaceGridCell.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/20.
//  Copyright © 2019 Zedd. All rights reserved.
//

import UIKit
import SnapKit

final class PlaceGridCell: UICollectionViewCell {
    private let thumbnail: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.regular(size: 14)
//        label.font = UIFont.GyeonggiBatang.regular(size: 14)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 2
        label.font = UIFont.regular(size: 18)
//        label.font = UIFont.GyeonggiBatang.regular(size: 18)
        return label
    }()
    
    private let lockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "lock")
        return imageView
    }()
    
    private let dimBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.alpha = 0.6
        return view
    }()
    
    var content: MemoryPlace? {
        didSet {
            self.contentChanged()
        }
    }
    
    func setupUI() {
        self.addSubview(self.thumbnail)
        self.addSubview(self.dimBackView)
        self.addSubview(self.dateLabel)
        self.addSubview(self.titleLabel)
        self.addSubview(self.lockImageView)
        
        self.thumbnail.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        self.dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(13)
            $0.left.equalToSuperview().offset(12)
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.dateLabel.snp.bottom).offset(4)
            $0.left.equalTo(self.dateLabel.snp.left)
            $0.right.equalToSuperview().offset(12)
        }
        
        self.lockImageView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-13)
            $0.bottom.equalToSuperview().offset(-12)
        }
        
        self.dimBackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        if content!.isLock {
            self.lockImageView.isHidden = false
            self.dimBackView.isHidden = false
            self.dimBackView.alpha = 0.6
        } else {
            self.lockImageView.isHidden = true
            self.dimBackView.isHidden = false
            
            self.dimBackView.alpha = 0.3
        }
    }
    
    private func contentChanged() {
        self.thumbnail.image = UIImage(data: self.content!.image)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let date = formatter.string(from: self.content!.date)
        
        self.dateLabel.text = date
        self.titleLabel.text = self.content!.title
    }
}
