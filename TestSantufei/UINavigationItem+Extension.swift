//
//  UINavigationItem+Extension.swift
//  TestSantufei
//
//  Created by Zhaniya Zhukesheva on 16/12/2019.
//  Copyright © 2019 Zhaniya Zhukesheva. All rights reserved.
//

import UIKit

extension UINavigationItem {
    
    func setTitle(title: String, subtitle: String) {
        
        let one = UILabel()
        one.text = title
        one.textColor = .white
        one.font = UIFont.systemFont(ofSize: 17)
        one.sizeToFit()
        
        let two = UILabel()
        two.text = subtitle
        two.textColor = .white
        two.font = UIFont.systemFont(ofSize: 12)
        two.textAlignment = .center
        two.sizeToFit()
        
        let stackView = UIStackView(arrangedSubviews: [one, two])
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        stackView.alignment = .center
        
        let width = max(one.frame.size.width, two.frame.size.width)
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: 35)
        
        one.sizeToFit()
        two.sizeToFit()
        
        self.titleView = stackView
    }
}
