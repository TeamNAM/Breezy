//
//  NewTripViewController.swift
//  Breezy
//
//  Created by Matthew Goo on 10/16/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftValidator

@objc protocol NewTripViewControllerDelegate {
    func newTripViewController(newTripViewController: NewTripViewController, addNewTrip trip: Trip)
}

class NewTripViewController: UIViewController, PlaceLookupViewDelegate, ValidationDelegate {
    static let storyboardID = "NewTripViewController"
    static func instantiateFromStoryboard() -> UIViewController {
        return UIStoryboard(name: storyboardID, bundle: nil).instantiateViewControllerWithIdentifier(storyboardID)
    }
    
    var dateFormatter: NSDateFormatter!
    var currentDatePickerView: UIDatePicker?
    var beginDate: NSDate?
    var endDate: NSDate?
    var place: Place? {
        didSet {
            setTripLocationTextField()
        }
    }
    
    weak var delegate: NewTripViewControllerDelegate?

    
    @IBOutlet weak var mapTapperView: UIView!
    @IBOutlet weak var locationMapView: GMSMapView!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var beginDateTextField: UITextField!
    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var tripLocationTextField: UITextField!
    
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter =  NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        locationMapView.userInteractionEnabled = false;
        
        mapTapperView.userInteractionEnabled = true
        let mapTapGesture = UITapGestureRecognizer(target: self, action: Selector("didTapMapView:"))
        mapTapperView.addGestureRecognizer(mapTapGesture)
        
        registerValidationFields()
        
        setTripLocationTextField()
    }
    
    // MARK: - PlaceLookupViewControllerDelegate
    
    func placeLookupViewController(placeLookupViewController: PlaceLookupViewController, didSelectPlace selectedPlace: Place) {
        place = selectedPlace
    }
   
    // MARK: - Date Management
    
    @IBAction func endDateEdit(input: UITextField) {
        let datePickerView = getDatePickerView(input)
        currentDatePickerView = datePickerView
        if endDate == nil {
            if beginDate != nil {
                
            } else {
                endDateValueChanged(datePickerView)
            }
        } else {
            datePickerView.date = endDate!
        }
        datePickerView.addTarget(self, action: Selector("endDateValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }

    @IBAction func beginDateEdit(input: UITextField) {
        let datePickerView = getDatePickerView(input)
        currentDatePickerView = datePickerView
        if beginDate == nil {
            beginDateValueChanged(datePickerView)
        } else {
            datePickerView.date = beginDate!
        }
        datePickerView.addTarget(self, action: Selector("beginDateValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func beginDateValueChanged(datePicker:UIDatePicker) {
        beginDateTextField.text = dateFormatter.stringFromDate(datePicker.date)
        beginDate = datePicker.date
    }
    
    func endDateValueChanged(datePicker:UIDatePicker) {
        endDateTextField.text = dateFormatter.stringFromDate(datePicker.date)
        endDate = datePicker.date
    }
    
    private func getDatePickerView(input: UITextField) -> UIDatePicker {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        input.inputView = datePickerView
        input.inputAccessoryView = getUiToolbar()
        return datePickerView
    }
    
    private func getUiToolbar() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 40))
        toolbar.barStyle = UIBarStyle.Default
        toolbar.tintColor = UIColor.blackColor()
        toolbar.backgroundColor = UIColor.greenColor()
        
        let toolbarClose = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "closeDatePicker:")
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let toolbarToday = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.Done, target: self, action: "selectToday:")
        
        toolbar.items = [toolbarClose, flexSpace, toolbarToday]
        return toolbar
    }
    
    func selectToday(sender: UIBarButtonItem) {
        let today = NSDate()
        currentDatePickerView?.setDate(today, animated: true)
        endDateTextField.resignFirstResponder()
        beginDateTextField.resignFirstResponder()
    }
    
    // MARK: - Location
    
    private func editLocation() {
        let vc = PlaceLookupViewController.instantiateFromStoryboardForPushSegue(self, toSelectPlaceType: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func locationEdit(sender: UITextField) {
        editLocation()
    }
    
    func didTapMapView(sender: UIView) {
        editLocation()
    }
    
    func closeDatePicker(sender: UIBarButtonItem) {
        // todo: mgoo Do I need both?
        endDateTextField.resignFirstResponder()
        beginDateTextField.resignFirstResponder()
    }
    
    func setTripLocationTextField() {
        if let place = self.place {
            if let tripLocationTextField = self.tripLocationTextField {
                tripLocationTextField.text = place.formattedAddress
                tripNameTextField.text = place.name
                locationMapView.camera = GMSCameraPosition.cameraWithLatitude(place.lat, longitude: place.lng, zoom: 13)
                
                let marker = GMSMarker()
                let coordinates =
                CLLocationCoordinate2D(latitude: place.lat, longitude: place.lng)
                marker.position = coordinates
                marker.map = self.locationMapView
            }
        }
    }
    
//    func setWeatherForTrip() {
//
//            ForecastIOClient.sharedInstance.forecast(<#T##latitude: Double##Double#>, longitude: <#T##Double#>, time: <#T##NSDate?#>, extendHourly: <#T##Bool?#>, exclude: <#T##[ForecastBlocks]?#>, failure: <#T##FailureClosure?##FailureClosure?##(error: NSError) -> Void#>, success: <#T##SuccessClosure?##SuccessClosure?##(forecast: Forecast, forecastAPICalls: Int?) -> Void#>)
//
//
//            ForecastIOClient.sharedInstance.forecast(place.lat, longitude: place.lng) { (forecast, forecastAPICalls) -> Void in
//            let currentTemperature = Int(round(forecast.currently!.temperature!))
//            self.temperaturesByUUID[place.uuid] = currentTemperature
//            print("\(1000 - forecastAPICalls!) Forecast API calls left today")
//            dispatch_async(dispatch_get_main_queue()) {
//                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
//            }
//    }
    
    // MARK: - Saving Trip
    
    @IBAction func saveTrip(sender: AnyObject) {
        validator.validate(self)
    }
    
    func validationSuccessful() {
        self.navigationController?.popViewControllerAnimated(true)
        let trip = Trip(startDate: beginDate!, endDate: endDate!, place: place!, name: tripNameTextField.text)
        delegate?.newTripViewController(self, addNewTrip: trip)
    }
    
    func validationFailed(errors:[UITextField:ValidationError]) {
        // turn the fields to red
        for (field, error) in validator.errors {
            field.layer.borderColor = UIColor.redColor().CGColor
            field.layer.borderWidth = 1.0
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.hidden = false
        }
    }
    
    func registerValidationFields() {
        validator.registerField(tripNameTextField, rules: [RequiredRule()])
        validator.registerField(beginDateTextField, rules: [RequiredRule()])
        validator.registerField(endDateTextField, rules: [RequiredRule()])
    }
    
    // MARK: - Navigation
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let tripsVc = segue.destinationViewController as! TripsViewController
//    }

    
    
}
