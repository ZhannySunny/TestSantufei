//
//  Cities.swift
//  TestSantufei
//
//  Created by Zhaniya Zhukesheva on 27/11/2019.
//  Copyright © 2019 Zhaniya Zhukesheva. All rights reserved.
//

import Foundation

struct AllCitiesResults: Decodable  {
    
    var count: Int
    var next : String?
    var previous: String?
    var results: [CityInfo]
}

struct CityInfo: Decodable {
    
    var id: Int
    var country_name: String
    var country_name_ru: String?
    var code: String
    var name: String
    var lat: Double?
    var lng: Double?
    var timezone: String?
    var gmt: Int?
    var autocomplete_enabled: Bool
    var name_ru: String?
    var state: Int?
    
    var country: Country
}

struct Country: Decodable {
    
    var id: Int
    var population: Int?
    var code: String
    var code2: String?
    var name: String
    var continent: String
    var name_ru: String?
    var currency_code: String?
    var currency_name: String?
    var languages: String?
    
}
