//
//  UIFont+.swift
//  Plock
//
//  Created by Zedd on 10/08/2019.
//  Copyright © 2019 Zedd. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    // AppleSDGothicNeo
    class func bold(size: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Bold", size: size)!
    }
    
    class func semibold(size: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Semibold", size: size)!
    }
    
    class func medium(size: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Medium", size: size)!
    }
    
    class func regular(size: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Regular", size: size)!
    }
    
    class func light(size: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Light", size: size)!
    }
    
    class func thin(size: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Thin", size: size)!
    }
    
    class func ultraLight(size: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-UltraLight", size: size)!
    }
    
    //
    class GyeonggiBatang {
        
        class func bold(size: CGFloat) -> UIFont {
            return UIFont(name: "GyeonggiBatang-Bold", size: size)!
        }
        
        class func regular(size: CGFloat) -> UIFont {
            return UIFont(name: "GyeonggiBatangR", size: size)!
        }
    }
    
    class GyeonggiTitle {
        
        class func bold(size: CGFloat) -> UIFont {
            return UIFont(name: "GyeonggiTitle-Bold", size: size)!
        }
        
        class func light(size: CGFloat) -> UIFont {
            return UIFont(name: "GyeonggiTitle-Light", size: size)!
        }
        
        class func medium(size: CGFloat) -> UIFont {
            return UIFont(name: "GyeonggiTitle-Medium", size: size)!
        }
    }
}
