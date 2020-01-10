//
//  FirstViewController+Extensions.swift
//  TestSantufei
//
//  Created by Zhaniya Zhukesheva on 07/12/2019.
//  Copyright © 2019 Zhaniya Zhukesheva. All rights reserved.
//

import UIKit
import CalendarDateRangePickerViewController

//MARK: TextFieldDelegate

extension FirstViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}

//MARK: CalendarDateRangePickerViewController

extension FirstViewController: CalendarDateRangePickerViewControllerDelegate {
    
    func didCancelPickingDateRange() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func didPickDateRange(startDate: Date!, endDate: Date!) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMM, E"
        self.endDate.isHidden = false
        self.startDate.text = dateFormatter.string(from: startDate)
        self.endDate.text = dateFormatter.string(from: endDate)
        
        self.navigationController?.dismiss(animated: true, completion: nil)
        self.segmentedControl.selectedSegmentIndex = 1
        self.findTicketsButton.isHidden = false
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        tripDetails.firstDate = dateFormatter.string(from: startDate)
        tripDetails.secondDate = dateFormatter.string(from: endDate)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.locale = Locale(identifier: "ru_RU")
        dateFormatter1.dateFormat = "d MMM, E"
        tripDetails.firstDateForTitle = dateFormatter1.string(from: startDate)
        tripDetails.secondDateForTitle = dateFormatter1.string(from: endDate)
            
        
        UIView.animate(withDuration: 0.7) {
            self.secondCalendarItem.alpha = 1.0
            self.view.layoutIfNeeded()
        }
        
        //widthReturnConstraint.constant = view.frame.width / 2 - 10
        
        view.endEditing(true)
    }
}

//MARK: UICollectionViewController methods

extension FirstViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularCities.cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cityCell", for: indexPath) as? PopularCitiesCollectionViewCell {
            
            let city = popularCities.cities[indexPath.item]
            cell.setCell(destination: city)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension FirstViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.bounds.width
        let cellDimension = (width / 2) - 15
        return CGSize(width: cellDimension, height: cellDimension)
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource methods

extension FirstViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showingCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CitiTableViewCell
        cell.configure(name: showingCities[indexPath.row].name_ru ?? showingCities[indexPath.row].name, country: showingCities[indexPath.row].country_name_ru ?? showingCities[indexPath.row].country_name, code: showingCities[indexPath.row].code)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if fromCountry.isFirstResponder {
            tripDetails.fromCity = showingCities[indexPath.row]
            fromCountry.text = (showingCities[indexPath.row].name_ru ?? showingCities[indexPath.row].name) + " (\(showingCities[indexPath.row].code))"
        } else if whereCountry.isFirstResponder {
            tripDetails.toCity = showingCities[indexPath.row]
            whereCountry.text = (showingCities[indexPath.row].name_ru ?? showingCities[indexPath.row].name) + " (\(showingCities[indexPath.row].code))"
        }
        
        showingCities.removeAll()
        searchTableView.reloadData()
        view.endEditing(true)
    }
}

