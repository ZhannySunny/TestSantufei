//
//  TicketDetailsViewController.swift
//  TestSantufei
//
//  Created by Zhaniya Zhukesheva on 25/12/2019.
//  Copyright © 2020 Zhaniya Zhukesheva. All rights reserved.
//

import UIKit

class TicketDetailsViewController: UIViewController {
    
    @IBOutlet weak var airplImg: UIImageView!
    @IBOutlet weak var airplCompany: UILabel!
    @IBOutlet weak var ticketPrice: UILabel!
    @IBOutlet weak var plane: UIImageView!
    @IBOutlet weak var departureDate: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var departureCity: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var arrivalCity: UILabel!
    @IBOutlet weak var clockImg: UIImageView!
    @IBOutlet weak var flightTime: UILabel!
    @IBOutlet weak var backPlane: UIImageView!
    @IBOutlet weak var backDate: UILabel!
    @IBOutlet weak var backDepartTime: UILabel!
    @IBOutlet weak var backDepartCity: UILabel!
    @IBOutlet weak var backArrivTime: UILabel!
    @IBOutlet weak var backArrivCity: UILabel!
    @IBOutlet weak var backFlightTime: UIImageView!
    @IBOutlet weak var flightTimeBack: UILabel!
    @IBOutlet weak var backClockImg: UIImageView!
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var detailedTicketView: UIView!
    
    
    @IBOutlet weak var dTime: UILabel!
    @IBOutlet weak var dCity: UILabel!
    @IBOutlet weak var dDate: UILabel!
    @IBOutlet weak var dCode: UILabel!
    @IBOutlet weak var logoPlane: UIImageView!
    @IBOutlet weak var dflightTime: UILabel!
    @IBOutlet weak var dReis: UILabel!
    @IBOutlet weak var dAirline: UILabel!
    @IBOutlet weak var aTime: UILabel!
    @IBOutlet weak var aCity: UILabel!
    @IBOutlet weak var aDate: UILabel!
    @IBOutlet weak var aCode: UILabel!
    
    
    @IBOutlet weak var backDTime: UILabel!
    @IBOutlet weak var backDCity: UILabel!
    @IBOutlet weak var backDDate: UILabel!
    @IBOutlet weak var backCityCode: UILabel!
    @IBOutlet weak var backLogoPlane: UIImageView!
    @IBOutlet weak var bckFlightTime: UILabel!
    @IBOutlet weak var backReis: UILabel!
    @IBOutlet weak var backAirline: UILabel!
    @IBOutlet weak var backATime: UILabel!
    @IBOutlet weak var backACity: UILabel!
    @IBOutlet weak var backADate: UILabel!
    @IBOutlet weak var backACityCode: UILabel!
    
    
    var ticketDetails: Itinerary?
    var cellImage: String?
    var tripDetails = TripDetails()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        showTicketDetails()
    }
    
    private func showTicketDetails() {
        
        if let myTicket = self.ticketDetails {
            
            let fromCity = myTicket.options[0].flights[0]
            let backCity = myTicket.options[0].flights[1]
            //let logo = airlineLogos?.get(code: myTicket.validatingAirline.code)
            
            airplCompany.text = myTicket.validatingAirline.name
            ticketPrice.text = String(myTicket.price.formattedWithSeparator) + " ₸"
            departureDate.text = fromCity.legs[0].departure.humanReadable.date
            departureTime.text = fromCity.legs[0].departure.humanReadable.time
            departureCity.text = fromCity.legs[0].origin.city.code  + " —"
            arrivalTime.text = fromCity.legs[0].arrival.humanReadable.time
            arrivalCity.text = fromCity.legs.last!.destination.city.code
            flightTime.text = fromCity.timeReadable
            backDate.text = backCity.legs[0].arrival.humanReadable.date
            backDepartTime.text = backCity.legs[0].departure.humanReadable.time
            backDepartCity.text = backCity.legs[0].origin.city.code + " —"
            backArrivTime.text = backCity.legs[0].arrival.humanReadable.time
            backArrivCity.text = backCity.legs.last!.destination.city.code
            flightTimeBack.text = backCity.timeReadable
            airplImg.imageFromUrl(urlString: cellImage!)
            
            dTime.text = fromCity.legs[0].departure.humanReadable.time
            dCity.text = fromCity.legs[0].origin.city.name
            dDate.text = fromCity.legs[0].departure.humanReadable.date
            dflightTime.text = fromCity.timeReadable
            aTime.text = fromCity.legs[0].arrival.humanReadable.time
            aCity.text = fromCity.legs.last!.destination.city.name
            aDate.text = backCity.legs[0].arrival.humanReadable.date
            dReis.text = "\(fromCity.legs[0].marketingAirline.code + "-" + fromCity.legs[0].marketingAirline.flightNumber + ",  " + fromCity.legs[0].airplane.name)"
            dAirline.text = myTicket.validatingAirline.name
            dCode.text = fromCity.legs[0].origin.city.code
            aCode.text = fromCity.legs.last!.destination.city.code
            
            backDTime.text = backCity.legs[0].departure.humanReadable.time
            backDCity.text = backCity.legs[0].origin.city.name
            backDDate.text = backCity.legs[0].arrival.humanReadable.date
            backCityCode.text = backCity.legs[0].origin.city.code
            bckFlightTime.text = backCity.timeReadable
            backReis.text = "\(backCity.legs[0].marketingAirline.code + "-" + backCity.legs[0].marketingAirline.flightNumber + ",  " + backCity.legs[0].airplane.name)"
            backAirline.text = myTicket.validatingAirline.name
            backATime.text = backCity.legs[0].arrival.humanReadable.time
            backACity.text = backCity.legs.last!.destination.city.name
            backADate.text = backCity.legs[0].arrival.humanReadable.date
            backACityCode.text = backCity.legs.last!.destination.city.code
            
            
        }
    }
    
    private func configUI() {
        
        if let firstCity = tripDetails.fromCity, let secondCity = tripDetails.toCity {
            self.navigationItem.setTitle(title: "\(firstCity.code) - \(secondCity.code)", subtitle: "\(tripDetails.firstDateForTitle) - \(tripDetails.secondDateForTitle)")
        }
        
        self.view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        self.view.addSubview(content)
        self.view.addSubview(detailedTicketView)
        content.backgroundColor = UIColor.white
        detailedTicketView.backgroundColor = UIColor.white

        
        let planeLogo = UIImage(named: "departurePlain")
        let planeTintableImage = planeLogo!.withRenderingMode(.alwaysTemplate)
        plane.image = planeTintableImage
        logoPlane.image = planeTintableImage
        backLogoPlane.image = planeTintableImage
        plane.tintColor = UIColor(red: 47/255, green: 212/255, blue: 191/255, alpha: 1.0)
        logoPlane.tintColor = UIColor(red: 47/255, green: 212/255, blue: 191/255, alpha: 1.0)
        
        let clockLogo = UIImage(named: "clock")
        let clockTintableImage = clockLogo!.withRenderingMode(.alwaysTemplate)
        clockImg.image = clockTintableImage
        backClockImg.image = clockTintableImage
        clockImg.tintColor = UIColor.gray
        backClockImg.tintColor = UIColor.gray
        
        let backPlaneLogo = UIImage(named: "backPlain")
        let backPlaneTintableImage = backPlaneLogo!.withRenderingMode(.alwaysTemplate)
        backPlane.image = backPlaneTintableImage
        backPlane.tintColor = UIColor(red: 31/255, green: 147/255, blue: 241/255, alpha: 1.0)

    }
    

}


extension UIImageView {
    
    func imageFromUrl(urlString: String) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async() {
                    
                    self.image = UIImage(data: data)
                    
                }
            }
            task.resume()
        }
    }
    
}
