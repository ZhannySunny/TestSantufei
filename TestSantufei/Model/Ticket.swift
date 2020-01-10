//
//  Ticket.swift
//  TestSantufei
//
//  Created by Zhaniya Zhukesheva on 02/12/2019.
//  Copyright © 2019 Zhaniya Zhukesheva. All rights reserved.
//

import Foundation

struct Ticket: Codable {
    
    let cards: [Card]?
    let airlineLogos: AirlineLogos?
    let uid: String?
    
    let messageHeader: String?
    let message: String?
    let errorCode: Int?
    let error: Bool?
    
    enum CodingKeys: String, CodingKey {
        case cards
        case airlineLogos = "airline_logos"
        case uid
        
        case messageHeader = "message_header"
        case message
        case errorCode = "error_code"
        case error
    }
}

// MARK: - AirlineLogos
struct AirlineLogos: Codable {
    
    let dv, kc, kca, z9, iq: AirlineParameters?
    let hr, u6, s7, the7R: AirlineParameters?
    let su, lh, tk, pc: AirlineParameters?
    
    func get(code: String) -> AirlineParameters? {
        
        if code == "HR" { return hr }
        if code == "U6" { return u6 }
        if code == "S7" { return s7 }
        if code == "7R" { return the7R }
        if code == "SU" { return su }
        if code == "DV" { return dv }
        if code == "KC" { return kc }
        if code == "KCA" { return kca }
        if code == "Z9" { return z9 }
        if code == "LH" { return lh }
        if code == "TK" { return tk }
        if code == "PC" { return pc }
        if code == "IQ" { return iq }
        
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case dv = "DV"
        case kc = "KC"
        case kca = "KCA"
        case z9 = "Z9"
        case iq = "IQ"
        case hr = "HR"
        case u6 = "U6"
        case s7 = "S7"
        case the7R = "7R"
        case su = "SU"
        case lh = "LH"
        case tk = "TK"
        case pc = "PC"

        
    }
}

// MARK: - The7_R
struct AirlineParameters: Codable {
    
    let code: String
    let logoHdpi: String
    let name: String
    let logoXxhdpi, logoXhdpi, logo2X, logo3X: String
    let logoMdpi: String
    let str: String
    let logoXxxhdpi, logo: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case logoHdpi = "logo_hdpi"
        case name
        case logoXxhdpi = "logo_xxhdpi"
        case logoXhdpi = "logo_xhdpi"
        case logo2X = "logo2x"
        case logo3X = "logo3x"
        case logoMdpi = "logo_mdpi"
        case str
        case logoXxxhdpi = "logo_xxxhdpi"
        case logo
    }
}


// MARK: - Card
struct Card: Codable {
    
    let itineraries: [Itinerary]
    let optionsCount: Int
    let airline: AirlineParameters
    
    enum CodingKeys: String, CodingKey {
        case itineraries
        case optionsCount = "options_count"
        case airline
    }
}

// MARK: - Itinerary
struct Itinerary: Codable {
    
    let price: Int
    let validatingAirline: AtingAirline
    let currency: String
    let priceKZT: String
    let options: [Option]
    let sequenceNumber: String
    
    enum CodingKeys: String, CodingKey {
        case price
        case validatingAirline = "validating_airline"
        case currency
        case priceKZT = "price_KZT"
        case options
        case sequenceNumber = "sequence_number"
    }
}

// MARK: - Option
struct Option: Codable {
    
    let isAgency: Bool
    let currency: String
    let agencyCommission: Int
    let brandable: Bool
    let measurement: String
    let duration: Int
    let bookable: Bool
    let combinationID: String
    let flights: [Flight]
    let refundableMessage: String
    let refundable: Bool
    let priceBreakdown: PriceBreakdown
    let isAlternative: Bool
    let price: Int
    let validatingAirline: AtingAirline
    let gdsType: Int
    let serviceFee: Int
    let priceKZT: String
    let owcValidatingAirlines: OwcValidatingAirlines
    let departure: String?
    let stopsCount: Int
    let baggage: Int
    let uniqueID: String
    let baggageRaw: BaggageRaw
    let payablePassengersCount: Int
    let sequenceNumber: String
    
    enum CodingKeys: String, CodingKey {
        case isAgency = "is_agency"
        case currency
        case agencyCommission = "agency_commission"
        case brandable, measurement, duration, bookable
        case combinationID = "combination_id"
        case flights
        case refundableMessage = "refundable_message"
        case refundable
        case priceBreakdown = "price_breakdown"
        case isAlternative = "is_alternative"
        case price
        case validatingAirline = "validating_airline"
        case gdsType = "gds_type"
        case serviceFee = "service_fee"
        case priceKZT = "price_KZT"
        case owcValidatingAirlines = "owc_validating_airlines"
        case departure
        case stopsCount = "stops_count"
        case baggage
        case uniqueID = "unique_id"
        case baggageRaw = "baggage_raw"
        case payablePassengersCount = "payable_passengers_count"
        case sequenceNumber = "sequence_number"
    }
}

// MARK: - BaggageRaw
struct BaggageRaw: Codable {
    
    let count: Int
    let weight: Weight
    let unit: String
}

struct Weight: Codable {
    
    let str: String
    let int: Int
    
    // Where we determine what type the value is
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // Check for a boolean
        do {
            str = try container.decode(String.self)
            int = 0
        } catch {
            // Check for an integer
            int = try container.decode(Int.self)
            str = ""
        }
    }
    
    // We need to go back to a dynamic type, so based on the data we have stored, encode to the proper type
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try str != "" ? container.encode(str) : container.encode(int)
    }
}

// MARK: - Flight
struct Flight: Codable {
    
    let timeReadable: String
    let refNumber: String?
    let stops: [Stop]
    let minPrice: Int
    let time: String
    let duration: Int
    let legs: [Leg]
    
    enum CodingKeys: String, CodingKey {
        case timeReadable = "time_readable"
        case refNumber = "ref_number"
        case stops
        case minPrice = "min_price"
        case time, duration, legs
    }
}

// MARK: - Leg
struct Leg: Codable {
    
    let arrival: Arrival
    let origin: Destination
    let fareClass: String
    let originTerminal: String?
    let timeReadable: String
    let seats: String
    let serviceClass: String
    let destination: Destination
    let measurement: String
    let departure: Arrival
    let baggage: Int?
    let flightNumber, time: String
    let baggageRaw: BaggageRaw
    let destinationTerminal: String?
    let fareBasis: String
    let airplane: Airplane
    let operatingAirline: AtingAirline
    let marketingAirline: MarketingAirline
    let serviceClassReadable: ServiceClassReadable?
    
    enum CodingKeys: String, CodingKey {
        case arrival, origin
        case fareClass = "fare_class"
        case originTerminal = "origin_terminal"
        case timeReadable = "time_readable"
        case seats
        case serviceClass = "service_class"
        case destination, measurement, departure, baggage
        case flightNumber = "flight_number"
        case time
        case baggageRaw = "baggage_raw"
        case destinationTerminal = "destination_terminal"
        case fareBasis = "fare_basis"
        case airplane
        case operatingAirline = "operating_airline"
        case marketingAirline = "marketing_airline"
        case serviceClassReadable = "service_class_readable"
    }
}

// MARK: - Airplane
struct Airplane: Codable {
    
    let code: String
    let name: String
}

// MARK: - Arrival
struct Arrival: Codable {
    
    let dayTime: Int
    let datetime: String
    let humanReadable: HumanReadable
    let fullDate: String
    
    enum CodingKeys: String, CodingKey {
        case dayTime = "day_time"
        case datetime
        case humanReadable = "human_readable"
        case fullDate = "full_date"
    }
}

// MARK: - HumanReadable
struct HumanReadable: Codable {
    
    let date: String
    let time: String
}

// MARK: - Destination
struct Destination: Codable {
    
    let city: City
    let code: String
    let name: String
    let country: Airplane
    let utcOffsetHours: Int
    let isAlternative: Bool?
    let pk: Int
    
    enum CodingKeys: String, CodingKey {
        case city, code, name, country
        case utcOffsetHours = "utc_offset_hours"
        case isAlternative = "is_alternative"
        case pk
    }
}

// MARK: - City
struct City: Codable {
    
    let country: Airplane
    let code: String
    let name: String
}


// MARK: - MarketingAirline
struct MarketingAirline: Codable {
    
    let flightNumber: String
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case flightNumber = "flight_number"
        case code
    }
}

// MARK: - AtingAirline
struct AtingAirline: Codable {
    
    let code: String
    let name: String
    let str: String
}

// MARK: - ServiceClassReadable
struct ServiceClassReadable: Codable {
    
    let ru: String
    let en: String
}

// MARK: - Stop
struct Stop: Codable {
    
    let waitingTimeMinute: Int
    let locationCode: String
    let location: Destination
    let diffAirports: Bool
    let waitingTime: String
    
    enum CodingKeys: String, CodingKey {
        case waitingTimeMinute = "waiting_time_minute"
        case locationCode = "location_code"
        case location
        case diffAirports = "diff_airports"
        case waitingTime = "waiting_time"
    }
}

// MARK: - OwcValidatingAirlines
struct OwcValidatingAirlines: Codable {
    
}

// MARK: - PriceBreakdown
struct PriceBreakdown: Codable {
    
    let fare, agencyCommission, total, taxes: Int
    let serviceFee: Int
    
    enum CodingKeys: String, CodingKey {
        case fare
        case agencyCommission = "agency_commission"
        case total, taxes
        case serviceFee = "service_fee"
    }
}
