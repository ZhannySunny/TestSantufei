//
//  TripDetails.swift
//  TestSantufei
//
//  Created by Zhaniya Zhukesheva on 03/12/2019.
//  Copyright © 2019 Zhaniya Zhukesheva. All rights reserved.
//

import Foundation

struct TripDetails {
    
    var fromCity: CityInfo?
    var toCity: CityInfo?
    
    var firstDate: String = ""
    var secondDate: String = ""
    
    var firstDateForTitle: String = ""
    var secondDateForTitle: String = ""
    
    var serviceType: ServiceType = .ECNM
    var countPeople = (adlt: 1, child: 0, inf: 0)
}
