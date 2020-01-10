//
//  UIColor+Extension.swift
//  TestSantufei
//
//  Created by Zhaniya Zhukesheva on 02/12/2019.
//  Copyright © 2019 Zhaniya Zhukesheva. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(rgbValue: UInt32, alpha: Double = 1.0) {
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8) / 256.0
        let blue = CGFloat(rgbValue & 0xFF) / 256.0
        
        self.init(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
}


