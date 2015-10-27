//
//  TripDetailViewController.swift
//  Breezy
//
//  Created by Matthew Goo on 10/26/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit

class TripDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var weatherTableView: UITableView!
    var dateFormatter: NSDateFormatter!
    
    var trip: Trip! {
        didSet {
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let weatherDayCellNib = UINib(nibName: "WeatherDayCell", bundle: NSBundle.mainBundle())
        weatherTableView.registerNib(weatherDayCellNib, forCellReuseIdentifier: "WeatherDayCell")
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        
        dateFormatter =  NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("WeatherDayCell", forIndexPath: indexPath) 
//        let cell = tableView.dequeueReusableCellWithIdentifier("WeatherDayCell", forIndexPath: indexPath) as! WeatherDayCell
//        cell.weather = trip.weather[indexPath.row]
//        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0 //trip.weather.count
    }
    func setupDetailView() {
        tripNameLabel.text = trip.place?.name
        datesLabel.text = "\(dateFormatter.stringFromDate(trip.startDate!)) - \(dateFormatter.stringFromDate(trip.endDate!))"
        
    }

}
