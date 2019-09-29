//
//  MemoryAnnotationView.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/18.
//  Copyright © 2019 Zedd. All rights reserved.
//

import Foundation
import MapKit

final class MemoryAnnotationView: MKAnnotationView {
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var backgroundFrameImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "alram")
        return imgView
    }()
    
    private lazy var contentImageView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    private lazy var lockImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "lock")
        return imgView
    }()
    
    private lazy var dimView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.3
        return view
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        displayPriority = .defaultHigh
        self.calloutOffset = CGPoint(x: -5, y: 5)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        guard let memory = self.annotation as? MemoryAnnotation else { return }
        
        self.contentImageView.image = memory.image
        if memory.isLock {
            dimView.isHidden = false
            lockImageView.isHidden = false
        } else {
            dimView.isHidden = true
            lockImageView.isHidden = true
        }
        
        self.addSubview(containerView)
    }
    
    private func setupUI() {
        self.containerView.addSubview(backgroundFrameImgView)
        self.containerView.addSubview(contentImageView)
        self.containerView.addSubview(dimView)
        self.containerView.addSubview(lockImageView)
        
        backgroundFrameImgView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentImageView.snp.makeConstraints {
            $0.top.equalTo(backgroundFrameImgView.snp.top).offset(5)
            $0.left.equalTo(backgroundFrameImgView.snp.left).offset(5)
            $0.right.equalTo(backgroundFrameImgView.snp.right).offset(-5)
            $0.bottom.equalTo(backgroundFrameImgView.snp.bottom).offset(-17)
        }
        
        containerView.snp.makeConstraints {
            $0.width.equalTo(64)
            $0.height.equalTo(74.5)
        }
        
        dimView.snp.makeConstraints {
            $0.top.equalTo(contentImageView.snp.top)
            $0.left.equalTo(contentImageView.snp.left)
            $0.right.equalTo(contentImageView.snp.right)
            $0.bottom.equalTo(contentImageView.snp.bottom)
        }
        
        lockImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(dimView)
        }
    }
}
