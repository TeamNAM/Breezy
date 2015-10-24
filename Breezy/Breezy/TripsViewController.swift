//
//  TripsViewController.swift
//  Breezy
//
//  Created by Matthew Goo on 10/16/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit
import ForecastIOClient

let apiTrips = [["name": "Mexico", "address": "1800 Paradise Dr. Hermosillo Mx 02932"]]

class TripsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PlaceLookupViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var tripTableView: UITableView!
    var trips = apiTrips
    
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
        return trips.count == 0 ? 1 : trips.count+1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("AddTripCell", forIndexPath: indexPath) as! AddTripCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("TripCell", forIndexPath: indexPath) as! TripCell
            cell.place = trips[indexPath.row - 1]
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
        let vc = PlaceLookupViewController.instantiateFromStoryboardForModalSegue(self, toSelectPlaceType: PlaceType.Other)
        presentViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: - PlaceLookupViewControllerDelegate
    func placeLookupViewController(placeLookupViewController: PlaceLookupViewController, didSelectPlace selectedPlace: Place) {
        let newTripController = NewTripViewController.instantiateFromStoryboard() as! NewTripViewController
        newTripController.place = selectedPlace
        self.navigationController?.pushViewController(newTripController, animated: true)
    }
    
    private func loadWeatherForPlace(place: Place, completion: (() -> ())? = nil) {
//        ForecastIOClient.sharedInstance.forecast(<#T##latitude: Double##Double#>, longitude: <#T##Double#>, time: <#T##NSDate?#>, extendHourly: <#T##Bool?#>, exclude: <#T##[ForecastBlocks]?#>, failure: <#T##FailureClosure?##FailureClosure?##(error: NSError) -> Void#>, success: <#T##SuccessClosure?##SuccessClosure?##(forecast: Forecast, forecastAPICalls: Int?) -> Void#>)
        
        
        ForecastIOClient.sharedInstance.forecast(place.lat, longitude: place.lng) { (forecast, forecastAPICalls) -> Void in
            let currentTemperature = Int(round(forecast.currently!.temperature!))
//            self.temperaturesByUUID[place.uuid] = currentTemperature
            print("\(1000 - forecastAPICalls!) Forecast API calls left today")
//            dispatch_async(dispatch_get_main_queue()) {
//                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
//            }
        }
    }

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("he")
//        let newTripVc = segue.destinationViewController as! NewTripViewController
    }

}
