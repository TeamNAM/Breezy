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
    
    var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDetailView()
        
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("SuggestionCell", forIndexPath: indexPath) as! SuggestionCell
            cell.suggestion = trip!.suggestions![indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("DayWeatherCell", forIndexPath: indexPath) as! DayWeatherCell
            if let trip = trip {
                let date = trip.dateRange![indexPath.row]
                cell.forecast = trip.forecast[date]
            }
            return cell
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let trip = trip {
            if section == 0 {
                if let suggestions = trip.suggestions {
                    return suggestions.count
                }
                
                return 0
            } else {
                if let dates = trip.dateRange {
                    return dates.count
                }
            }
        }
        return 0
    }
    
    func setupDetailView() {
        if let trip = trip {
            tripNameLabel.text = trip.place?.name
            if let sDate = trip.startDateString {
                if let eDate = trip.endDateString {
                    print(sDate)
                    print(eDate)
                    datesLabel.text = "\(sDate) - \(eDate)"
                }
            }
        }
    }
    
}
