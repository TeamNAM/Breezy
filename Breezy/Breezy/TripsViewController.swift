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
            cell.place = trip.place
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableView.cellForRowAtIndexPath(indexPath) is AddTripCell {
            addNewTrip()
        }
    }
    
    private func addNewTrip() {
//        let newTripController = NewTripViewController.instantiateFromStoryboard() as! NewTripViewController
//        self.navigationController?.pushViewController(newTripController, animated: true)
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
    
    private func loadWeatherForPlace(place: Place, completion: (() -> ())? = nil) {
//        ForecastIOClient.sharedInstance.forecast(<#T##latitude: Double##Double#>, longitude: <#T##Double#>, time: <#T##NSDate?#>, extendHourly: <#T##Bool?#>, exclude: <#T##[ForecastBlocks]?#>, failure: <#T##FailureClosure?##FailureClosure?##(error: NSError) -> Void#>, success: <#T##SuccessClosure?##SuccessClosure?##(forecast: Forecast, forecastAPICalls: Int?) -> Void#>)
        
        
        ForecastIOClient.sharedInstance.forecast(place.lat, longitude: place.lng) { (forecast, forecastAPICalls) -> Void in
//            let currentTemperature = Int(round(forecast.currently!.temperature!))
//            self.temperaturesByUUID[place.uuid] = currentTemperature
//            print("\(1000 - forecastAPICalls!) Forecast API calls left today")
//            dispatch_async(dispatch_get_main_queue()) {
//                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
//            }
        }
    }
    
    // MARK - Add New Trip
    
    func newTripViewController(newTripViewController: NewTripViewController, addNewTrip trip: Trip) {
        print("new trip added")
        trips!.append(trip)
        tripTableView.reloadData()
    }
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
