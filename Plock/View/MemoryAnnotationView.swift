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
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let backgroundFrameImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "alram")
        return imgView
    }()
    
    private let contentImageView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    private let lockImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "lock")
        return imgView
    }()
    
    private let dimView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.3
        return view
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        guard let memory = self.annotation as? MemoryAnnotation else { return }
        displayPriority = .defaultHigh
        self.canShowCallout = true
        self.calloutOffset = CGPoint(x: -5, y: 5)
        self.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

        self.contentImageView.image = memory.image
        self.containerView.addSubview(self.backgroundFrameImgView)
        self.containerView.addSubview(self.contentImageView)
        self.containerView.addSubview(self.dimView)
        self.containerView.addSubview(self.lockImageView)
        
        self.backgroundFrameImgView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        self.contentImageView.snp.makeConstraints {
            $0.top.equalTo(self.backgroundFrameImgView.snp.top).offset(5)
            $0.left.equalTo(self.backgroundFrameImgView.snp.left).offset(5)
            $0.right.equalTo(self.backgroundFrameImgView.snp.right).offset(-5)
            $0.bottom.equalTo(self.backgroundFrameImgView.snp.bottom).offset(-17)
        }

        self.containerView.snp.makeConstraints {
            $0.width.equalTo(64)
            $0.height.equalTo(74.5)
        }

        self.dimView.snp.makeConstraints {
            $0.top.equalTo(contentImageView.snp.top)
            $0.left.equalTo(contentImageView.snp.left)
            $0.right.equalTo(contentImageView.snp.right)
            $0.bottom.equalTo(contentImageView.snp.bottom)
        }

        self.lockImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(dimView)
        }

        if memory.isLock {
            self.dimView.isHidden = false
            self.lockImageView.isHidden = false
        } else {
            self.dimView.isHidden = true
            self.lockImageView.isHidden = true
        }

        self.addSubview(containerView)
    }
}
