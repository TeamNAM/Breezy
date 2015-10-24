//
//  NewTripViewController.swift
//  Breezy
//
//  Created by Matthew Goo on 10/16/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit
import GoogleMaps

class NewTripViewController: UIViewController, PlaceLookupViewDelegate {
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

    
    @IBOutlet weak var mapTapperView: UIView!
    @IBOutlet weak var locationMapView: GMSMapView!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var beginDateTextField: UITextField!
    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var tripLocationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter =  NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        locationMapView.userInteractionEnabled = false;
        
        mapTapperView.userInteractionEnabled = true
        let mapTapGesture = UITapGestureRecognizer(target: self, action: Selector("didTapMapView:"))
        mapTapperView.addGestureRecognizer(mapTapGesture)
        
        setTripLocationTextField()
    }
    
    // MARK: - PlaceLookupViewControllerDelegate
    func placeLookupViewController(placeLookupViewController: PlaceLookupViewController, didSelectPlace selectedPlace: Place) {
        place = selectedPlace
    }
   
    @IBAction func beginDateEdit(input: UITextField) {
        let datePickerView = getDatePickerView(input)
        currentDatePickerView = datePickerView
        datePickerView.addTarget(self, action: Selector("beginDateValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func endDateEdit(input: UITextField) {
        let datePickerView = getDatePickerView(input)
        currentDatePickerView = datePickerView
        datePickerView.addTarget(self, action: Selector("endDateValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
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
    
    @IBAction func saveTrip(sender: AnyObject) {
        
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
    
    func setTripLocationTextField() {
        if let place = self.place {
            if let tripLocationTextField = self.tripLocationTextField {
                tripLocationTextField.text = place.formattedAddress
                locationMapView.camera = GMSCameraPosition.cameraWithLatitude(place.lat, longitude: place.lng, zoom: 13)
                
                let marker = GMSMarker()
                let coordinates =
                CLLocationCoordinate2D(latitude: place.lat, longitude: place.lng)
                marker.position = coordinates
                marker.map = self.locationMapView
            }
        }
    }

}
