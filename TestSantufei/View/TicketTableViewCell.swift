//
//  TicketTableViewCell.swift
//  TestSantufei
//
//  Created by Zhaniya Zhukesheva on 14/12/2019.
//  Copyright © 2019 Zhaniya Zhukesheva. All rights reserved.
//

import UIKit

class TicketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nameCompany: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var departureCity: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var arrivalCity: UILabel!
    @IBOutlet weak var departurePlain: UIImageView!
    @IBOutlet weak var backPlain: UIImageView!
    @IBOutlet weak var backDate: UILabel!
    @IBOutlet weak var backDepartTime: UILabel!
    @IBOutlet weak var backDepartCity: UILabel!
    @IBOutlet weak var backArrivalTime: UILabel!
    @IBOutlet weak var backArrivalCity: UILabel!
    
    @IBOutlet weak var content: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        content.layer.shadowColor = UIColor.black.cgColor
        content.layer.shadowOpacity = 0.2
        content.layer.shadowRadius = 14.0
        content.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        
        let myImage = UIImage(named: "departurePlain")
        let tintableImage = myImage!.withRenderingMode(.alwaysTemplate)
        departurePlain.image = tintableImage
        departurePlain.tintColor = UIColor(red: 47/255, green: 212/255, blue: 191/255, alpha: 1.0)
        
        
        let myImage1 = UIImage(named: "backPlain")
        let tintableImage1 = myImage1?.withRenderingMode(.alwaysTemplate)
        backPlain.image = tintableImage1
        backPlain.tintColor = UIColor(red: 31/255, green: 147/255, blue: 241/255, alpha: 1.0)

    }

    func configure(nameCompany: String, price: Int, departureDate: String, departureTime: String, departureCity: String, arrivalTime: String, arrivalCity: String, backDate: String, backDepartTime: String, backDepartCity: String, backArrivTime: String, backArrivCity: String, logoUrl: String) {
        
    
        self.nameCompany.text = nameCompany
        self.priceLabel.text = "\(price.formattedWithSeparator) ₸"
        self.dateLabel.text = "\(departureDate)"
        self.departureTime.text = "\(departureTime)"
        self.departureCity.text = "\(departureCity)"
        self.arrivalTime.text = "\(arrivalTime)"
        self.arrivalCity.text = "\(arrivalCity)"
        self.backDate.text = "\(backDate)"
        self.backDepartTime.text = "\(backDepartTime)"
        self.backDepartCity.text = "\(backDepartCity)"
        self.backArrivalTime.text = "\(backArrivTime)"
        self.backArrivalCity.text = "\(backArrivCity)"
        
        imageFromUrl(urlString: logoUrl)
    }
    
    public func imageFromUrl(urlString: String) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }

                DispatchQueue.main.async() {
                    
                    self.logoImage.image = UIImage(data: data)
                    
                }
            }
            task.resume()
        }
    }
}
