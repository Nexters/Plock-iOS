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
        
        let containerView = UIView()
        let backgroundFrame = UIImageView()
        backgroundFrame.image = UIImage(named: "alram")
        
        let contentImageView = UIImageView()
        contentImageView.image = memory.image
        
        let lockImageView = UIImageView()
        lockImageView.image = UIImage(named: "lock")
        
        let dimView = UIView()
        dimView.backgroundColor = .black
        dimView.alpha = 0.3
        
        containerView.addSubview(backgroundFrame)
        containerView.addSubview(contentImageView)
        containerView.addSubview(dimView)
        containerView.addSubview(lockImageView)
        
        backgroundFrame.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentImageView.snp.makeConstraints {
            $0.top.equalTo(backgroundFrame.snp.top).offset(5)
            $0.left.equalTo(backgroundFrame.snp.left).offset(5)
            $0.right.equalTo(backgroundFrame.snp.right).offset(-5)
            $0.bottom.equalTo(backgroundFrame.snp.bottom).offset(-17)
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
        
        if memory.isLock {
            dimView.isHidden = false
            lockImageView.isHidden = false
        } else {
            dimView.isHidden = true
            lockImageView.isHidden = true
        }
        
        self.addSubview(containerView)
    }
}
