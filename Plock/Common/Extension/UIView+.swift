//
//  UIView+.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/02.
//  Copyright © 2019 Zedd. All rights reserved.
//
import SnapKit

extension UIView {
    var safeArea: ConstraintBasicAttributesDSL {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        }
        return self.snp
    }
    
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
    }
    
    var isIphoneX: Bool{
        get{
            if #available(iOS 11.0, *) {
                if topSafeAreaInset > CGFloat(0) {
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
        }
    }
    
    var topSafeAreaInset: CGFloat{
        let window = UIApplication.shared.keyWindow
        var topPadding : CGFloat = 0
        if #available(iOS 11.0, *) {
            topPadding = window?.safeAreaInsets.top ?? 0
        }
        
        return topPadding
    }
    
    var bottomSafeAreaInset: CGFloat{
        let window = UIApplication.shared.keyWindow
        var bottomPadding : CGFloat = 0
        if #available(iOS 11.0, *) {
            bottomPadding = window?.safeAreaInsets.bottom ?? 0
        }
        
        return bottomPadding
    }
}
