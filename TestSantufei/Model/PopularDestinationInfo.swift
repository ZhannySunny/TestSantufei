//
//  PopularDestinationInfo.swift
//  TestSantufei
//
//  Created by Zhaniya Zhukesheva on 02/12/2019.
//  Copyright © 2019 Zhaniya Zhukesheva. All rights reserved.
//

import Foundation
import UIKit

struct PopularDestination {
    
    var cities: String
    var price: Int
    var cityImage: String
}

class PopularDestinationInfo {
    
    
    let cities = [PopularDestination(cities: "Стамбул", price: 54171, cityImage:"istanbul.jpg"),
                  PopularDestination(cities: "Москва", price: 38364, cityImage: "moscow.jpg"),
                  PopularDestination(cities: "Сеул", price: 107536, cityImage: "seul.jpg"),
                  PopularDestination(cities: "Санкт-Петербург", price: 59445, cityImage: "piter.jpg"),
                  PopularDestination(cities: "Ташкент", price: 38924, cityImage: "tashkent.jpg"),
                  PopularDestination(cities: "Тбилиси", price: 70047, cityImage: "tbilisi.jpg"),
                  PopularDestination(cities: "Нью-Йорк", price: 159141, cityImage: "newyork.jpg"),
                  PopularDestination(cities: "Прага", price: 68783, cityImage: "praga.jpg")]

}


extension String {
    
    func toDouble() -> Double {
        
        let price = self as NSString
        return price.doubleValue
        
    }
    
    func toInt() -> Int {
        
        let price = self as NSString
        let myInt = price.integerValue
        return myInt
    }
    
    
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Int {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}

