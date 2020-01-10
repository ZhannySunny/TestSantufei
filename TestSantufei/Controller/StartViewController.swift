//
//  StartViewController.swift
//  TestSantufei
//
//  Created by Zhaniya Zhukesheva on 15/12/2019.
//  Copyright © 2019 Zhaniya Zhukesheva. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    var allCities: [CityInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)
        
        NetworkManager.shared.getCityList { result in

            if let result = result {
                
                self.allCities = result
                self.performSegue(withIdentifier: "StartSegue", sender: self)

            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartSegue" {
            if let nextViewController = segue.destination as? FirstViewController {
                nextViewController.allCities = allCities
            }
        }
    }
}
