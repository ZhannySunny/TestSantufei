//
//  SecondViewController.swift
//  TestSantufei
//
//  Created by Zhaniya Zhukesheva on 17/12/2019.
//  Copyright © 2019 Zhaniya Zhukesheva. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var repeateButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    
    var tickets = [Itinerary]()
    var logos: AirlineLogos?
    var tripDetails = TripDetails()
    var logoToPass: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        searchTickets()
    }
    
    private func configUI() {
        
        repeateButton.isHidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TicketTableViewCell", bundle: nil), forCellReuseIdentifier: "TicketCell")
        
        if let firstCity = tripDetails.fromCity, let secondCity = tripDetails.toCity {
            self.navigationItem.setTitle(title: "\(firstCity.code) - \(secondCity.code)", subtitle: "\(tripDetails.firstDateForTitle) - \(tripDetails.secondDateForTitle)")
        }
    }
    
    private func searchTickets() {
        
        guard let firstCity = tripDetails.fromCity, let secondCity = tripDetails.toCity else {
            activityIndicator.stopAnimating()
            myLabel.text = "Ошибка. Недостаточно данных"
            return
        }
        
        NetworkManager.shared.searchTickets(fromCode: firstCity.code, toCode: secondCity.code, fromDate: tripDetails.firstDate, returnDate: tripDetails.secondDate) { result -> (Void) in
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
                if let error = result?.messageHeader, let errorDetails = result?.message {
                    self.repeateButton.isHidden = false
                    self.myLabel.text = error + "\n" + errorDetails

                } else if let tickets = result?.cards {
                
                    self.tickets.removeAll()
                    self.logos = result?.airlineLogos
                    tickets.forEach { self.tickets += $0.itineraries }
                    self.tableView.isHidden = false
                    self.loadingView.isHidden = true
                    self.tableView.reloadData()
                    
                } else {
                    self.myLabel.text = "Ошибка поиска (парсинга)"
                    self.repeateButton.isHidden = false
                }
            }
        }
    }

    
    @IBAction func backButtonPress(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if let detailVC = segue.destination as? TicketDetailsViewController {
                
                if let indexPath = tableView.indexPathForSelectedRow {
                    
                    let ticketParameters = tickets[indexPath.row]
                    detailVC.ticketDetails = ticketParameters
                    detailVC.tripDetails = tripDetails
                    detailVC.cellImage = logos?.get(code: ticketParameters.validatingAirline.code)?.logo3X ?? ""
                    

                }
            }
        }
    }




//MARK: UITableViewDelegate, UITableViewDataSource methods

extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell", for: indexPath) as! TicketTableViewCell
        let ticket = tickets[indexPath.row]
        let logo = logos?.get(code: ticket.validatingAirline.code)
        //print(ticket.options[0].departure)
        let fromCity = ticket.options[0].flights[0]
        let backCity = ticket.options[0].flights[1]
        
        
        cell.configure(nameCompany: ticket.validatingAirline.name, price: ticket.price,
            departureDate: fromCity.legs[0].departure.humanReadable.date,
            departureTime: fromCity.legs[0].departure.humanReadable.time,
            departureCity: fromCity.legs[0].origin.city.code + " — ",
            arrivalTime: fromCity.legs[0].arrival.humanReadable.time,
            arrivalCity: fromCity.legs.last!.destination.city.code,
            backDate: backCity.legs[0].arrival.humanReadable.date,
            backDepartTime: backCity.legs[0].departure.humanReadable.time,
            backDepartCity: backCity.legs[0].origin.city.code + " — ",
            backArrivTime: backCity.legs[0].arrival.humanReadable.time,
            backArrivCity: backCity.legs.last!.destination.city.code,
            logoUrl: logo?.logo3X ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
         performSegue(withIdentifier: "toTicketDetails", sender: self)
        
    }
}




//departureCity: ticket.options[0].flights[0].legs[0].origin.city.code + " - "
