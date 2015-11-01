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

class NewTripViewController: UIViewController, ValidationDelegate {
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
    
    var activeField: UITextField?
    var isEditingExistingTrip: Bool = false
    var isBeginDate: Bool = true
    
    weak var delegate: NewTripViewControllerDelegate?

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapTapperView: UIView!
    @IBOutlet weak var locationMapView: GMSMapView!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var beginDateTextField: UITextField!
    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var tripLocationTextField: UITextField!
    
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollEnabled = false
        
        dateFormatter =  NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        locationMapView.userInteractionEnabled = false;
        
        mapTapperView.userInteractionEnabled = true
        let mapTapGesture = UITapGestureRecognizer(target: self, action: Selector("didTapMapView:"))
        mapTapperView.addGestureRecognizer(mapTapGesture)
        
        registerValidationFields()
        
        setTripLocationTextField()
        
        registerForKeyboardNotifications()
        
        if isEditingExistingTrip {
            setTripLocationTextField()
            beginDateTextField.text = dateFormatter.stringFromDate(beginDate!)
            endDateTextField.text = dateFormatter.stringFromDate(endDate!)
        } else {
            beginDateTextField.becomeFirstResponder()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        deregisterFromKeyboardNotifications()
    }
    
    // MARK: - Date Management
    
    @IBAction func endDateEdit(input: UITextField) {
        isBeginDate = false
        let datePickerView = getDatePickerView(input)
        currentDatePickerView = datePickerView
        if endDate == nil {
            endDateValueChanged(datePickerView)
        } else {
            datePickerView.date = endDate!
        }
        datePickerView.addTarget(self, action: Selector("endDateValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }

    @IBAction func beginDateEdit(input: UITextField) {
        isBeginDate = true
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
        var toolbarClose: UIBarButtonItem!
        
        toolbar.barStyle = UIBarStyle.Default
        toolbar.tintColor = UIColor.blackColor()
        toolbar.backgroundColor = ColorPalette.orange
        
        if isBeginDate == true {
            toolbarClose = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Done, target: self, action: "goToEndDate:")
        } else {
            toolbarClose = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "closeDatePicker:")
        }
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let toolbarToday = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.Done, target: self, action: "selectToday:")
        
        toolbar.items = [toolbarToday, flexSpace, toolbarClose]
        return toolbar
    }
    
    func selectToday(sender: UIBarButtonItem) {
        let today = NSDate()
        currentDatePickerView?.setDate(today, animated: true)
        if isBeginDate {
            beginDateTextField.text = dateFormatter.stringFromDate(today)
        } else {
            endDateTextField.text = dateFormatter.stringFromDate(today)
        }
    }
    
    func closeDatePicker(sender: AnyObject) {
        // todo: mgoo Do I need both?
        endDateTextField.resignFirstResponder()
        beginDateTextField.resignFirstResponder()
    }
    
    func goToEndDate(sender: AnyObject) {
        endDateTextField.becomeFirstResponder()
    }
    
    // MARK: - Location
    
    private func editLocation() {
        let vc = PlaceLookupViewController.instantiateFromStoryboard()
        vc.placeSelectedHandler = { (selectedPlace: Place) -> Void in
            self.place = selectedPlace
            self.navigationController?.popViewControllerAnimated(true)
        }
        vc.lookupCanceledHandler = {
            self.navigationController?.popViewControllerAnimated(true)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func locationEdit(sender: UITextField) {
        editLocation()
    }
    
    func didTapMapView(sender: UIView) {
        editLocation()
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

    // MARK: - Saving Trip
    
    @IBAction func saveTrip(sender: AnyObject) {
        validator.validate(self)
        // if validation is successful this will call validationSuccessful()
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
    
    // MARK: - Edit Trip
    
    func editTrip(trip: Trip) {
        place = trip.place
        beginDate = trip.startDate
        endDate = trip.endDate
        isEditingExistingTrip = true
    }
    
    // MARK: - Keyboard
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        //Need to calculate keyboard exact size due to Apple suggestions
        scrollView.scrollEnabled = true
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let _ = activeField {
            if (!CGRectContainsPoint(aRect, activeField!.frame.origin)) {
                self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.scrollEnabled = false
    }
    
    func textFieldDidBeginEditing(textField: UITextField!) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField!) {
        activeField = nil
    }
    
    // MARK: - Navigation
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let tripsVc = segue.destinationViewController as! TripsViewController
//    }

    
    
}
