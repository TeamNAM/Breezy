//
//  TripDetailViewController.swift
//  Breezy
//
//  Created by Matthew Goo on 10/26/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit

class MultiDayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    static let storyboardID = "MultiDayViewController"
    static func instantiateFromStoryboard() -> UIViewController {
        return UIStoryboard(name: storyboardID, bundle: nil).instantiateViewControllerWithIdentifier(storyboardID)
    }
    
    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var weatherTableView: UITableView!
    var dateFormatter: NSDateFormatter!
    
    var trip: Trip! {
        didSet {
            setupDetailView()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDetailView()
        
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return tableView.dequeueReusableCellWithIdentifier("SuggestionCell", forIndexPath: indexPath)
        //        let cell = tableView.dequeueReusableCellWithIdentifier("WeatherDayCell", forIndexPath: indexPath) as! WeatherDayCell
        //        cell.weather = trip.weather[indexPath.row]
        //        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0 //trip.weather.count
    }
    
    func setupDetailView() {
        if let label = tripNameLabel {
            label.text = trip.place?.name
            if let sDate = trip.startDateString {
                if let eDate = trip.endDateString {
                    datesLabel.text = "\(sDate) - \(eDate)"
                }
            }
        }
    }
    
}
