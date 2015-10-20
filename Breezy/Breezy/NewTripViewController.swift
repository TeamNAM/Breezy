//
//  NewTripViewController.swift
//  Breezy
//
//  Created by Matthew Goo on 10/16/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit
import GoogleMaps

class NewTripViewController: UIViewController {
    
    
    var dateFormatter: NSDateFormatter!
    var currentDatePickerView: UIDatePicker?

    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var beginDateTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter =  NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
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
    }
    
    func endDateValueChanged(datePicker:UIDatePicker) {
        endDateTextField.text = dateFormatter.stringFromDate(datePicker.date)
    }
    
    func closeDatePicker(sender: UIBarButtonItem) {
        // todo: Do I need both?
        endDateTextField.resignFirstResponder()
        beginDateTextField.resignFirstResponder()
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



    /*x
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
