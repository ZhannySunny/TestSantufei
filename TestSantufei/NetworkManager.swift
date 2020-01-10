//
//  NetworkManager.swift
//  TestSantufei
//
//  Created by Zhaniya Zhukesheva on 14/12/2019.
//  Copyright © 2019 Zhaniya Zhukesheva. All rights reserved.
//

import Foundation

enum ServiceType: String {
    
    case FRST
    case BSNS
    case ECNM
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func searchTickets(fromCode: String, toCode: String, fromDate: String, returnDate: String?, adt: Int = 1, chd: Int = 0, inf: Int = 0, service_type: ServiceType = .ECNM, completion: @escaping (Ticket?) -> (Void)) {
    
        ///api/v1/tickets/search/?segment=ALA_MOW_2016-01-27&segment=MOW_ALA_2016-01-30
        
        var urlString = "https://test.santufei.com/api/v1/tickets/search/?segment=\(fromCode)_\(toCode)_\(fromDate)"
        
        if let date = returnDate {
            urlString.append("&segment=\(toCode)_\(fromCode)_\(date)")
        }
        
        urlString.append("&ADT=\(adt)")
        
        if chd > 0 {
            urlString.append("&CHD=\(chd)")
        }
        
        else {
            urlString.append("")
        }
        
        if inf > 0 {
            urlString.append("&INF=\(inf)")
        }
        
        else {
            urlString.append("")
        }
        
        urlString.append("&service_type=\(service_type.rawValue)")

        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in

                if let jsonData = data {
                    let decoder = JSONDecoder()
                    do {
                        let tickets = try decoder.decode(Ticket.self, from: jsonData)
                        print("Success parse json")
                        completion(tickets)
                        
                    } catch {
                        print("Unable parse json", error)
                        completion(nil)
                    }
                } else {
                    print("Unable parse response data")
                    completion(nil)
                }
            }.resume()
        }
    }
    
    func getCityList(completion: @escaping ([CityInfo]?) -> (Void)) {
        
        let myGroup = DispatchGroup()
        var citiesList: [CityInfo] = []
       
        for index in 1...108 {
            if let url = URL(string: "https://test.santufei.com/api/v1/location/cities/?page=\(index)&page_size=100") {
               
                myGroup.enter()
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    
                    if let jsonData = data {
                        let decoder = JSONDecoder()

                        do {
                            let cities = try decoder.decode(AllCitiesResults.self, from: jsonData)
                            citiesList += cities.results
                        } catch {
                            print(error)
                        }
                    }
                    myGroup.leave()
                }.resume()
            }
        }
        
        myGroup.notify(queue: .main) {
            print("All done")
            completion(citiesList)
        }
    }
}
