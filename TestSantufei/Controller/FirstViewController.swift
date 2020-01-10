//
//  MainViewController.swift
//  TestSantufei
//
//  Created by Zhaniya Zhukesheva on 25/11/2019.
//  Copyright © 2019 Zhaniya Zhukesheva. All rights reserved.
//

import UIKit
import CalendarDateRangePickerViewController

class FirstViewController: UIViewController {
    
    @IBOutlet weak var fromCountry: UITextField!
    @IBOutlet weak var whereCountry: UITextField!
    
    @IBOutlet weak var passengersType: UIButton!
    @IBOutlet weak var classType: UIButton!
    
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var findTicketsButton: UIButton!
    @IBOutlet weak var bottomTopCityView: UIView!
    
    @IBOutlet weak var passengerGroup: UIStackView!
    @IBOutlet weak var addPassengerButton: UIButton!
    @IBOutlet weak var minusPassengerButton: UIButton!
    @IBOutlet weak var passengerCountLabel: UILabel!
    
    @IBOutlet weak var addChildrenButton: UIButton!
    @IBOutlet weak var minusChildrenButton: UIButton!
    @IBOutlet weak var childrenCountLabel: UILabel!
    
    @IBOutlet weak var addBabyButton: UIButton!
    @IBOutlet weak var minusBabyButton: UIButton!
    @IBOutlet weak var babyCountLabel: UILabel!
    
    @IBOutlet weak var widthReturnConstraint: NSLayoutConstraint!
    @IBOutlet weak var startDateTextFieldLeading: NSLayoutConstraint!
    @IBOutlet weak var startDateTextFieldTrailing: NSLayoutConstraint!
    @IBOutlet weak var secondCalendarItem: UIImageView!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var topCollectionConstraint: NSLayoutConstraint!
    
    let popularCities = PopularDestinationInfo()
    var isBusinessClass = false
    
    var tripDetails = TripDetails()
    var allCities: [CityInfo] = []
    var showingCities: [CityInfo] = []
    var collectionViewHeight = 0
    
    private enum PassengerOperator {
        case plus
        case minus
    }
    
    private enum Constants {
        
        static let segmentedControlHeight: CGFloat = 40
        static let underlineViewColor: UIColor = .orange
        static let underlineViewHeight: CGFloat = 3
        static let segmentedControlFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    // Container view of the segmented control
    private lazy var segmentedControlContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    // Customised segmented control
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.backgroundColor = .black
        segmentedControl.tintColor = .black
        segmentedControl.insertSegment(withTitle: "В одну сторону", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "В обе стороны", at: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.contentMode = .scaleAspectFit
        
        // Change text color and the font of the NOT selected (normal) segment
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: Constants.segmentedControlFont], for: .normal)
        
        // Change text color and the font of the selected segment
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: Constants.underlineViewColor,
            NSAttributedString.Key.font: Constants.segmentedControlFont], for: .selected)
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    // The underline view below the segmented control
    
    private lazy var bottomUnderlineView: UIView = {
        let underlineView = UIView()
        underlineView.backgroundColor = Constants.underlineViewColor
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        return underlineView
    }()
    
    private lazy var leadingDistanceConstraint: NSLayoutConstraint = {
        return bottomUnderlineView.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UISettings()
        configureConstraints()
        
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.register(UINib(nibName: "CitiTableViewCell", bundle: nil), forCellReuseIdentifier: "CityCell")

        collectionView.dataSource = self
        collectionView.delegate = self
        
        addPassengerButton.addTarget(self, action: #selector(addPassenger), for: .touchUpInside)
        minusPassengerButton.addTarget(self, action: #selector(minusPassenger), for: .touchUpInside)
        
        addChildrenButton.addTarget(self, action: #selector(addMoreChild), for: .touchUpInside)
        minusChildrenButton.addTarget(self, action: #selector(minusChild), for: .touchUpInside)
        
        addBabyButton.addTarget(self, action: #selector(addBaby), for: .touchUpInside)
        minusBabyButton.addTarget(self, action: #selector(minusBaby), for: .touchUpInside)
        
        classType.addTarget(self, action: #selector(changeClassType), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //collectionViewHeight = Int(collectionView.frame.height)
    }
    
    //MARK: Button Actions
    
    @IBAction func changeCities(_ sender: Any) {
        (tripDetails.fromCity, tripDetails.toCity) = (tripDetails.toCity, tripDetails.fromCity)
        (fromCountry.text, whereCountry.text) = (whereCountry.text, fromCountry.text)
    }
    
    @objc func changeClassType() {
        isBusinessClass = !isBusinessClass
        tripDetails.serviceType = isBusinessClass ? .BSNS : .ECNM
        let titleText = isBusinessClass ? "Бизнес" : "Эконом"
        classType.setTitle(titleText, for: .normal)
    }
    
    @objc func addBaby() {
        updatePassenger(label: babyCountLabel, action: .plus)
        tripDetails.countPeople.inf = Int(babyCountLabel.text ?? "0") ?? 0
    }
    
    @objc func minusBaby() {
        updatePassenger(label: babyCountLabel, action: .minus)
        tripDetails.countPeople.inf = Int(babyCountLabel.text ?? "0") ?? 0
    }
    
    @objc func addPassenger() {
        updatePassenger(label: passengerCountLabel , action: .plus)
        tripDetails.countPeople.adlt = Int(passengerCountLabel.text ?? "1") ?? 1
    }
    
    @objc func minusPassenger() {
        updatePassenger(label: passengerCountLabel, action: .minus)
        tripDetails.countPeople.adlt = Int(passengerCountLabel.text ?? "1") ?? 1
    }
    
    @objc func addMoreChild() {
        updatePassenger(label: childrenCountLabel, action: .plus)
        tripDetails.countPeople.child = Int(childrenCountLabel.text ?? "0") ?? 0
    }
    
    @objc func minusChild() {
        updatePassenger(label: childrenCountLabel, action: .minus)
        tripDetails.countPeople.child = Int(childrenCountLabel.text ?? "0") ?? 0
    }

    private func updateTotalPassenger() {
        
        guard let countPassengerText = passengerCountLabel.text, let countPassenter = Int(countPassengerText) else {
            print("Error with passengers counter")
            return
        }
        
        guard let countChildText = childrenCountLabel.text, let countChild = Int(countChildText) else {
            print("Error with childs counter")
            return
        }
        
        guard let countBabyText = babyCountLabel.text, let countBaby = Int(countBabyText) else {
            print("Error with baby counter")
            return
        }
        
        passengersType.setTitle("\(countPassenter + countChild + countBaby) пассажиров", for: .normal)
    }
    
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        let segmentIndex = CGFloat(segmentedControl.selectedSegmentIndex)
        let segmentWidth = segmentedControl.frame.width / 2
        let leadingDistance = segmentWidth * segmentIndex
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.leadingDistanceConstraint.constant = leadingDistance
            self?.loadViewIfNeeded()
        })
        
        if segmentedControl.selectedSegmentIndex == 0 {
            self.endDate.isHidden = true
            
            UIViewPropertyAnimator(duration: 0.7, curve: .easeOut, animations: {
                self.secondCalendarItem.alpha = 0.0
            }).startAnimation()
            
            let widthConstraint = self.view.bounds.width - 15
            widthReturnConstraint.constant = widthConstraint * 0.5
            UIView.animate(withDuration: 0.7) {
                self.view.layoutIfNeeded()
            }
        } else if segmentedControl.selectedSegmentIndex == 1 {
            
            self.endDate.isHidden = false
            
            UIViewPropertyAnimator(duration: 0.7, curve: .easeIn, animations: {
                self.secondCalendarItem.alpha = 1.0
            }).startAnimation()
            
            widthReturnConstraint.constant = 0
            UIView.animate(withDuration: 0.7) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func expandDateTextFieldWidth() {
        startDateTextFieldLeading.constant = 0.0
        startDateTextFieldTrailing.constant = 0.0
    }
    
    @IBAction func fromWhichCity(_ sender: Any) {
        searchCity(textField: fromCountry)
    }
    
    @IBAction func toWhichCity(_ sender: Any) {
        searchCity(textField: whereCountry)
    }
        
    private func searchCity(textField: UITextField) {
        
        if let text = textField.text {
            let avCities = allCities.filter { city -> Bool in
                if let name = city.name_ru, name.contains(text) {
                    return true
                } else {
                    return false
                }
            }
            showingCities = avCities
            searchTableView.reloadData()
        }
        
        if let from = fromCountry.text, let to = whereCountry.text {
            
            var yPosition = 8
            if !from.isEmpty || !to.isEmpty {
                yPosition = collectionViewHeight - 50
            }

            topCollectionConstraint.constant = CGFloat(yPosition)
            UIView.animate(withDuration: 0.7, animations: {
                if yPosition == 8 {
                    self.bottomTopCityView.alpha = 1.0
                } else {
                    self.bottomTopCityView.alpha = 0.0
                }
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func selectDate(_ sender: UITextField) {
        
        let dateRangePickerViewController = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
        dateRangePickerViewController.delegate = self
        dateRangePickerViewController.minimumDate = Date()
        dateRangePickerViewController.maximumDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())
        dateRangePickerViewController.selectedStartDate = Date()
        
        let navigationController = UINavigationController(rootViewController: dateRangePickerViewController)
        self.navigationController?.present(navigationController, animated: true, completion: nil)
        findTicketsButton.isHidden = false 
    }
    
    @IBAction func selectCategoty(_ sender: UIButton) {
        passengerGroup.isHidden.toggle()
    }
    
    @IBAction func selectClass(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "findTicket" {
            if let nextViewController = segue.destination as? SecondViewController {
                nextViewController.tripDetails = tripDetails
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if tripDetails.fromCity == nil || tripDetails.toCity == nil  {
            let alert = UIAlertController(title: "Упс..", message: "Выберите города и даты полета!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default))
            present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    //MARK: Configure UI
    
    private func updatePassenger(label: UILabel, action: PassengerOperator) {
        
        guard let countText = label.text, let count = Int(countText) else {
            return
        }
        
        switch action {
        case .plus:
            label.text = String(count + 1)
        case .minus:
            if count == 0 {
                return
            }
            
            label.text = String(count - 1)
        }
        
        updateTotalPassenger()
    }
    
    private func configureConstraints() {
        
        // Add subviews to the view hierarchy
        // (both segmentedControl and bottomUnderlineView are subviews of the segmentedControlContainerView)
        view.addSubview(segmentedControlContainerView)
        segmentedControlContainerView.addSubview(segmentedControl)
        segmentedControlContainerView.addSubview(bottomUnderlineView)
        
        // Constrain the container view to the view controller
        let safeLayoutGuide = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            segmentedControlContainerView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            segmentedControlContainerView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            segmentedControlContainerView.widthAnchor.constraint(equalTo: safeLayoutGuide.widthAnchor),
            segmentedControlContainerView.heightAnchor.constraint(equalToConstant: Constants.segmentedControlHeight)
        ])
        
        // Constrain the segmented control to the container view
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: segmentedControlContainerView.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: segmentedControlContainerView.leadingAnchor),
            segmentedControl.centerXAnchor.constraint(equalTo: segmentedControlContainerView.centerXAnchor),
            segmentedControl.centerYAnchor.constraint(equalTo: segmentedControlContainerView.centerYAnchor)
        ])
        
        // Constrain the underline view relative to the segmented control
        NSLayoutConstraint.activate([
            bottomUnderlineView.bottomAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            bottomUnderlineView.heightAnchor.constraint(equalToConstant: Constants.underlineViewHeight),
            leadingDistanceConstraint,
            bottomUnderlineView.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / 2)
        ])
    }
    
    private func UISettings() {
        
        secondCalendarItem.alpha = 0.0
        let widthConstraint = self.view.bounds.width - 32
        widthReturnConstraint.constant = widthConstraint * 0.5
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationItem.setHidesBackButton(true, animated: true)

        if navigationController == nil {
            return
        }
        
        // Create a navView to add to the navigation bar
        let navView = UIView()
        
        // Create the label
        let label = UILabel()
        label.text = "santufei"
        label.textColor = .white
        label.sizeToFit()
        label.center = navView.center
        label.textAlignment = .center
        
        
        // Create the image view
        let image = UIImageView()
        image.image = UIImage(named: "santufei.png")
        let imageAspect = image.image!.size.width / image.image!.size.height
        
        // Setting the image frame so that it's immediately before the text:
        image.frame = CGRect(x: label.frame.origin.x-label.frame.size.height*imageAspect - 5, y: label.frame.origin.y, width: label.frame.size.height*imageAspect, height: label.frame.size.height)
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 6.0
        image.clipsToBounds = true
        navView.addSubview(label)
        navView.addSubview(image)
        
        navigationItem.titleView = navView
        navView.sizeToFit()
        
        passengersType.layer.borderColor = UIColor(rgbValue: 0xDFDFDF).withAlphaComponent(0.6).cgColor
        passengersType.layer.borderWidth = 0.5
        classType.layer.borderColor = UIColor(rgbValue: 0xDFDFDF).withAlphaComponent(0.6).cgColor
        classType.layer.borderWidth = 0.5
        
        navigationController?.navigationBar.barTintColor = .black
        endDate.isHidden = true
        findTicketsButton.isHidden = true
        startDate.frame.size.width = UIScreen.main.bounds.width
        passengerGroup.isHidden = true
        passengerGroup.backgroundColor = .gray
    }
}
