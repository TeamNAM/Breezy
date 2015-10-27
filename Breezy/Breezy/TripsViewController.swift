//
//  TripsViewController.swift
//  Breezy
//
//  Created by Matthew Goo on 10/16/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit
import ForecastIOClient

class TripsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PlaceLookupViewDelegate, NewTripViewControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var tripTableView: UITableView!
    var trips: [Trip]? = createFakeDays()
    
    // MARK: - Static initializer
    
    static func instantiateFromStoryboard() -> UIViewController {
        return UIStoryboard(name: storyboardID, bundle: nil).instantiateViewControllerWithIdentifier(storyboardID)
    }
    
    // MARK: Static properties
    
    static let storyboardID = "TripsViewController"
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addTripCellNib = UINib(nibName: "AddTripCell", bundle: NSBundle.mainBundle())
        let tripCellNib = UINib(nibName: "TripCell", bundle: NSBundle.mainBundle())
        
        if let trips = trips {
            for var i = 0; i < trips.count; ++i {
                let trip = trips[i]
                loadWeatherForTrip(trip)
            }
        }
        
        tripTableView.delegate = self
        tripTableView.dataSource = self
        
        tripTableView.registerNib(addTripCellNib, forCellReuseIdentifier: "AddTripCell")
        tripTableView.registerNib(tripCellNib, forCellReuseIdentifier: "TripCell")
        tripTableView.rowHeight = UITableViewAutomaticDimension
        tripTableView.estimatedRowHeight = 150
        tripTableView.reloadData()
    }
    

    @IBAction func didTapAddNewTrip(sender: UIBarButtonItem) {
        addNewTrip()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let trips = trips {
            return trips.count + 1
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("AddTripCell", forIndexPath: indexPath) as! AddTripCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("TripCell", forIndexPath: indexPath) as! TripCell
            let trip = trips![indexPath.row - 1]
            cell.trip = trip
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableView.cellForRowAtIndexPath(indexPath) is AddTripCell {
            addNewTrip()
        } else {
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            self.performSegueWithIdentifier("TripDetailSegue", sender: cell)
        }
    }
    
    private func addNewTrip() {
        let vc = PlaceLookupViewController.instantiateFromStoryboardForModalSegue(self, toSelectPlaceType: PlaceType.Other)
        presentViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: - PlaceLookupViewControllerDelegate
    func placeLookupViewController(placeLookupViewController: PlaceLookupViewController, didSelectPlace selectedPlace: Place) {
        let newTripController = NewTripViewController.instantiateFromStoryboard() as! NewTripViewController
        newTripController.place = selectedPlace
        newTripController.delegate = self
        self.navigationController?.pushViewController(newTripController, animated: true)
    }
    
    private func loadWeatherForTrip(trip: Trip, completion: (() -> ())? = nil) {
        let place = trip.place
        
//        let dateRange = getDateRange(trip.startDate!, endDate: trip.endDate!)
        
//        for var i=0; i< dateRange.count; i++ {
//            
//        }
            ForecastIOClient.sharedInstance.forecast(place!.lat, longitude: place!.lng, time: trip.startDate, extendHourly: true, exclude: [ForecastBlocks.Currently, ForecastBlocks.Minutely], failure: { (error) -> Void in
                    print(error)
                }) { (forecast, forecastAPICalls) -> Void in
                    if let daily = forecast.daily {
                        print(daily.data!.count)
                        if let data = daily.data {
                            for var i=0; i<data.count; i++ {
                                let point = data[i]
                                let tripData = Weather(icon: point.icon, precipProb: point.precipProbability, temp: point.temperature, time: point.time)
                                trip.weather.append(tripData)
                            }
                        }
                    }
        }
    }
    
    // MARK - Add New Trip
    
    func newTripViewController(newTripViewController: NewTripViewController, addNewTrip trip: Trip) {
        trips!.append(trip)
        loadWeatherForTrip(trip)
        tripTableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextVc = segue.destinationViewController
        if nextVc is TripDetailViewController {
            let tripDetailVc = nextVc as! TripDetailViewController
            let cell = sender as! TripCell
            tripDetailVc.trip = cell.trip
        }
        
    }
}

private func getDateRange(startDate: NSDate, endDate: NSDate) -> [NSDate] {
    let cal = NSCalendar.currentCalendar()
    
    let components = cal.components(NSCalendarUnit.Day, fromDate: startDate, toDate: endDate, options: NSCalendarOptions.MatchStrictly)
    
    var dates = [NSDate]()
    for var i=0; i<components.day; i++ {
        let unixDay:NSTimeInterval = Double(86400*i)
        let date = NSDate(timeInterval: unixDay, sinceDate: startDate)
        dates.append(date)
    }

    return dates
}



func createFakeDays() -> [Trip] {
    let dateFormatter = NSDateFormatter()
    let startDate1 = NSDate(dateString:"2015-11-06", dateStringFormatter: dateFormatter)
    let endDate1 = NSDate(dateString:"2015-11-15", dateStringFormatter: dateFormatter)
    let place1 = Place(lat: 32, lng: 121, name: "Mexico", formattedAddress: "707 Mexico", placeType: .Other, recommendationIcon: nil, recommendationMessage: nil, detailedMessage: nil)
    let trip1 = Trip(startDate: startDate1, endDate: endDate1, place: place1, name: "Mexico")
    
    let startDate2 = NSDate(dateString: "2015-12-02", dateStringFormatter: dateFormatter)
    let endDate2 = NSDate(dateString: "2015-12-24", dateStringFormatter: dateFormatter)
    let place2 = Place(lat: 43, lng: 135, name: "Oakland", formattedAddress: "707 Okalhoma st", placeType: .Other, recommendationIcon: nil, recommendationMessage: nil, detailedMessage: nil)
    let trip2 = Trip(startDate: startDate2, endDate: endDate2, place: place2, name: "Oakland")
    
    var fakeTrips = [Trip]()
    fakeTrips.append(trip1)
    fakeTrips.append(trip2)
    return fakeTrips

}
