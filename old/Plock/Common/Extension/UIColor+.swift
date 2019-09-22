//
//  UIColor+.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/13.
//  Copyright © 2019 Zedd. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    class func mainBlue() -> UIColor {
        return UIColor(red: 77, green: 173, blue: 247)
    }
    
    class func grey2() -> UIColor {
        return UIColor(red: 73, green: 80, blue: 87)
    }
    
    class func grey3() -> UIColor {
        return UIColor(red: 134, green: 142, blue: 150)
    }

    class func grey4() -> UIColor {
        return UIColor(red: 173, green: 181, blue: 189)
    }
    
    class func charcoalGrey() -> UIColor {
        return UIColor(red: 52, green: 58, blue: 64)
    }
}
