//
//  SearchPlaceCell.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/17.
//  Copyright © 2019 Zedd. All rights reserved.
//

import UIKit

final class SearchPlaceCell: UITableViewCell {
    
    // MARK: UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.medium(size: 14)
        label.textColor = .grey2()
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(size: 10)
        label.textColor = .grey3()
        return label
    }()
    
    // MARK: Constructor
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.subTitleLabel)
        
        self.layout()
    }
    
    func bind(_ viewModel: SearchPlaceItemViewModel) {
        self.titleLabel.text = viewModel.title
        self.subTitleLabel.text = viewModel.subTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UI Layout
extension SearchPlaceCell {
    private func layout() {
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }
        
        self.subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom)
            $0.left.equalTo(self.titleLabel)
            $0.right.equalToSuperview().offset(-24)
        }
    }
}
