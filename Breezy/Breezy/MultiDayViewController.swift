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
    @IBOutlet weak var detailsContainerView: UIView!
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var graphView: UIView!
    var dateFormatter: NSDateFormatter!
    
    var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDetailView()
        
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        weatherTableView.backgroundColor = UIColor.clearColor()
        detailsContainerView.backgroundColor = UIColor.clearColor()
        graphView.backgroundColor = UIColor.clearColor()
        
        setupBackgroundView()
    }
    
    func setupBackgroundView() {
        if let trip = trip {
            backgroundView.backgroundColor = ColorPalette.getAverageColorForTemp(trip.averageTemp!)
        }
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRectZero)
    }
    
    func setupDetailView() {
        if let trip = trip {
            tripNameLabel.text = trip.place?.name
            if let sDate = trip.startDateString {
                if let eDate = trip.endDateString {
                    datesLabel.text = "\(sDate) - \(eDate)"
                }
            }
        }
    }
    
}
