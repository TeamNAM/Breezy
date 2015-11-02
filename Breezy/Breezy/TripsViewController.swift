//
//  TripsViewController.swift
//  Breezy
//
//  Created by Matthew Goo on 10/16/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit
import ForecastIOClient

class TripsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewTripViewControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tripTableView: UITableView!
    var trips: [Trip]? = User.sharedInstance.trips
    
    // MARK: - Static initializer
    
    static func instantiateFromStoryboard() -> UIViewController {
        return UIStoryboard(name: storyboardID, bundle: nil).instantiateViewControllerWithIdentifier(storyboardID)
    }
    
    // MARK: Static properties
    
    static let storyboardID = "TripsViewController"
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let trips = User.sharedInstance.trips {
            for var i = 0; i < trips.count; ++i {
                let trip = trips[i]
                trip.loadForecast()
            }
        }
        
        setupTableView()
        setupBackgroundView()
    }
    
    private func setupTableView() {
        tripTableView.delegate = self
        tripTableView.dataSource = self
        tripTableView.backgroundView = nil
        tripTableView.backgroundColor = UIColor.clearColor()
        tripTableView.rowHeight = UITableViewAutomaticDimension
        tripTableView.estimatedRowHeight = 150
        tripTableView.reloadData()
    }
    
    private func setupBackgroundView() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = backgroundView.bounds

        let blue = UIColor(red: 141/255, green: 204/255, blue: 229/255, alpha: 1)
        let tan = UIColor(red: 223/255, green: 207/255, blue: 186/255, alpha: 1)
        gradient.colors = [blue.CGColor, tan.CGColor]
        backgroundView.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    @IBAction func didTapAddNewTrip(sender: UIBarButtonItem) {
        addNewTrip()
    }
    
    // MARK: - Table View
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let trips = User.sharedInstance.trips {
            if trips.count == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("AddTripCell", forIndexPath: indexPath)
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("TripCell", forIndexPath: indexPath) as! TripCell
                let trip = trips[indexPath.section]
                cell.trip = trip
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("AddTripCell", forIndexPath: indexPath)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell is TripCell {
            goToTripDetailView(cell as! TripCell)
        } else {
            addNewTrip()
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let trips = User.sharedInstance.trips {
            return trips.count > 0 ? trips.count : 1
        }
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.contentView.layer.cornerRadius = 7
        cell.contentView.layer.masksToBounds = true
        cell.contentView.layer.borderWidth = 2
        cell.backgroundColor = UIColor.clearColor()
    }
    
    // MARK: - Trip detail view
    
    private func goToTripDetailView(cell: TripCell) {
        let vc = ForecastDetailViewController.instantiateFromStoryboard() as! ForecastDetailViewController
        vc.trip = cell.trip
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - Adding trip
    
    private func addNewTrip() {
        let vc = PlaceLookupViewController.instantiateFromStoryboard()
        vc.placeSelectedHandler = { (selectedPlace: Place) -> Void in
            let newTripController = NewTripViewController.instantiateFromStoryboard() as! NewTripViewController
            newTripController.place = selectedPlace
            newTripController.delegate = self
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.navigationController?.pushViewController(newTripController, animated: true)
            })
        }
        vc.lookupCanceledHandler = {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let navVC = UINavigationController(rootViewController: vc)
        presentViewController(navVC, animated: true, completion: nil)
    }
    
    func newTripViewController(newTripViewController: NewTripViewController, addNewTrip trip: Trip) {
        User.sharedInstance.addTrip(trip)
//        trips!.append(trip)
        trip.loadForecast()
        tripTableView.reloadData()
    }
    
    // MARK: - Navigation
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let nextVc = segue.destinationViewController
//    }
}



func createFakeDays() -> [Trip] {
    let dateFormatter = NSDateFormatter()
    let startDate1 = NSDate(dateString:"2015-11-06", dateStringFormatter: dateFormatter)
    let endDate1 = NSDate(dateString:"2015-11-07", dateStringFormatter: dateFormatter)
    let place1 = Place(lat: 32, lng: 121, name: "Mexico", formattedAddress: "707 Mexico", recommendationIcon: nil, recommendationMessage: nil, detailedMessage: nil)
    let trip1 = Trip(startDate: startDate1, endDate: endDate1, place: place1, name: "Mexico")
    
//    let startDate2 = NSDate(dateString: "2015-12-02", dateStringFormatter: dateFormatter)
//    let endDate2 = NSDate(dateString: "2015-12-04", dateStringFormatter: dateFormatter)
//    let place2 = Place(lat: 43, lng: 135, name: "Oakland", formattedAddress: "707 Okalhoma st",recommendationIcon: nil, recommendationMessage: nil, detailedMessage: nil)
//    let trip2 = Trip(startDate: startDate2, endDate: endDate2, place: place2, name: "Oakland")
    
    var fakeTrips = [Trip]()
    fakeTrips.append(trip1)
//    fakeTrips.append(trip2)
    return fakeTrips
    
}
