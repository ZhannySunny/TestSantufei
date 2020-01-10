//
//  CitiTableViewCell.swift
//  TestSantufei
//
//  Created by Zhaniya Zhukesheva on 11/12/2019.
//  Copyright © 2019 Zhaniya Zhukesheva. All rights reserved.
//

import UIKit

class CitiTableViewCell: UITableViewCell {

    @IBOutlet private weak var cityName: UILabel!
    @IBOutlet private weak var countryName: UILabel!
    @IBOutlet weak var code: UILabel!
    
    func configure(name: String, country: String, code: String) {
        cityName.text = name
        countryName.text = country
        self.code.text = code
    }
}
