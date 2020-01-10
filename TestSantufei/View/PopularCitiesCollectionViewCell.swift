//
//  PopularCitiesCollectionViewCell.swift
//  TestSantufei
//
//  Created by Zhaniya Zhukesheva on 02/12/2019.
//  Copyright © 2019 Zhaniya Zhukesheva. All rights reserved.
//

import UIKit

class PopularCitiesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cityImgView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        cityImgView.layer.cornerRadius = 10
    }
    
    func setCell(destination: PopularDestination) {
        
        cityImgView.image = UIImage(named: destination.cityImage)
        cityNameLabel.text = destination.cities
        priceLabel.text = "от \(destination.price.formattedWithSeparator) ₸"
    }
}

