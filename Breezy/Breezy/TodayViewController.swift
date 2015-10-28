//
//  TodayViewController.swift
//  Breezy
//
//  Created by Matthew Goo on 10/20/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import ForecastIOClient
import UIKit

enum PlaceType: Int {
    case Home, Work, Other
}

class TodayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Static initializer
    
    static func instantiateFromStoryboard() -> UIViewController {
        return UIStoryboard(name: storyboardID, bundle: nil).instantiateViewControllerWithIdentifier(storyboardID)
    }
    
    // MARK: Static properties
    
    static let storyboardID = "TodayViewController"
    
    // MARK: - Properties

    @IBOutlet weak var tableView: UITableView!
    
    private let homeIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    private let workIndexPath = NSIndexPath(forRow: 1, inSection: 0)
    private var forecastByUUID = [String: Forecast]()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.allowsMultipleSelectionDuringEditing = false
        let todayViewCellNib = UINib(nibName: TodayViewCell.reuseIdentifier, bundle: NSBundle.mainBundle())
        tableView.registerNib(todayViewCellNib, forCellReuseIdentifier: TodayViewCell.reuseIdentifier)
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if let home = User.sharedInstance.home {
            self.loadWeatherForPlace(home, atIndexPath: self.homeIndexPath)
        }
        if let work = User.sharedInstance.work {
            self.loadWeatherForPlace(work, atIndexPath: self.workIndexPath)
        }
        for (i, place) in User.sharedInstance.otherPlaces.enumerate() {
            let indexPath = NSIndexPath(forRow: i, inSection: 1)
            self.loadWeatherForPlace(place, atIndexPath: indexPath)
        }
    }
    
    // MARK: - API Calls
    
    func loadWeatherForPlace(place: Place, atIndexPath indexPath: NSIndexPath, withCompletion completionHandler: (() -> ())? = nil) {
        // Only fetch weather if it's been longer than 5 minutes
        if let storedForecast = forecastByUUID[place.uuid] where NSDate().timeIntervalSince1970 - Double(storedForecast.currently!.time) < (60.0 * 5) {
            print("Using cached weather info")
            return
        }
        
        ForecastIOClient.sharedInstance.forecast(place.lat, longitude: place.lng) { (forecast: Forecast, forecastAPICalls) -> Void in
            self.forecastByUUID[place.uuid] = forecast
            print("\(1000 - forecastAPICalls!) Forecast API calls left today")
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TodayViewCell.reuseIdentifier) as! TodayViewCell
        let placeType = self.getPlaceTypeForIndexPath(indexPath)
        var place: Place?
        if indexPath == self.homeIndexPath {
            place = User.sharedInstance.home
        } else if indexPath == self.workIndexPath {
            place = User.sharedInstance.work
        } else {
            place = User.sharedInstance.otherPlaces[indexPath.row]
        }
        (cell.selectionStyle, cell.accessoryType) = self.getTableViewCellSelectionStyleAndAccessoryType(placeType, place: place)
        cell.data = [
            "placeType": placeType,
            "place": place,
            "forecast": place != nil ? forecastByUUID[place!.uuid] : nil
        ]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == self.homeIndexPath.section {
            return 2
        } else {
            return User.sharedInstance.otherPlaces.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Section 0 is home/work cells. Section 1 is "other places" cells
        return 2
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return !tableViewCellIsEmptyHomeOrWork(indexPath)
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if indexPath == self.homeIndexPath {
                User.sharedInstance.home = nil
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            } else if indexPath == self.workIndexPath {
                User.sharedInstance.work = nil
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            } else {
                let place = User.sharedInstance.otherPlaces[indexPath.row]
                User.sharedInstance.removeOtherPlace(place.uuid)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let placeType = self.getPlaceTypeForIndexPath(indexPath)
        guard [PlaceType.Home, PlaceType.Work].contains(placeType) else {
            return
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let vc = PlaceLookupViewController.instantiateFromStoryboard()
        vc.lookupCanceledHandler = {
            self.navigationController?.popViewControllerAnimated(true)
        }
        vc.placeSelectedHandler = { (selectedPlace: Place) -> Void in
            if placeType == PlaceType.Home {
                User.sharedInstance.home = selectedPlace
            } else {
                User.sharedInstance.work = selectedPlace
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.loadWeatherForPlace(selectedPlace, atIndexPath: indexPath)
            })
            self.navigationController?.popViewControllerAnimated(true)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return self.tableViewCellIsEmptyHomeOrWork(indexPath) ? indexPath : nil
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: - Table helpers
    
    func getPlaceTypeForIndexPath(indexPath: NSIndexPath) -> PlaceType {
        if indexPath == self.homeIndexPath {
            return PlaceType.Home
        } else if indexPath == self.workIndexPath {
            return PlaceType.Work
        } else {
            return PlaceType.Other
        }
    }
    
    func getTableViewCellSelectionStyleAndAccessoryType(placeType: PlaceType, place: Place?) -> (UITableViewCellSelectionStyle, UITableViewCellAccessoryType) {
        if [PlaceType.Home, PlaceType.Work].contains(placeType) && place == nil {
            return (UITableViewCellSelectionStyle.Default, UITableViewCellAccessoryType.DisclosureIndicator)
        } else {
            return (UITableViewCellSelectionStyle.None, UITableViewCellAccessoryType.None)
        }
    }
    
    func tableViewCellIsEmptyHomeOrWork(indexPath: NSIndexPath) -> Bool {
        return (indexPath == self.homeIndexPath && User.sharedInstance.home == nil) || (indexPath == self.workIndexPath && User.sharedInstance.work == nil)
    }
    
    // MARK: - Button Actions
    
    @IBAction func onAddPlace(sender: UIBarButtonItem) {
        let vc = PlaceLookupViewController.instantiateFromStoryboard()
        vc.lookupCanceledHandler = {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        vc.placeSelectedHandler = { (selectedPlace: Place) -> Void in
            User.sharedInstance.addOtherPlace(selectedPlace)
            let indexPath = NSIndexPath(forRow: User.sharedInstance.otherPlaces.count - 1, inSection: 1)
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.loadWeatherForPlace(selectedPlace, atIndexPath: indexPath)
            })
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let navVC = UINavigationController(rootViewController: vc)
        self.presentViewController(navVC, animated: true, completion: nil)
    }
}
