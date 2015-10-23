//
//  TodayViewController.swift
//  Breezy
//
//  Created by Matthew Goo on 10/20/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import ForecastIOClient
import UIKit

class TodayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PlaceLookupViewDelegate {
    
    // MARK: - Static initializer
    
    static func instantiateFromStoryboard() -> UIViewController {
        return UIStoryboard(name: storyboardID, bundle: nil).instantiateViewControllerWithIdentifier(storyboardID)
    }
    
    // MARK: - Properties
    
    static let storyboardID = "TodayViewController"

    @IBOutlet weak var tableView: UITableView!
    
    var temperaturesByUUID = [String: Int]()
    
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
        if let home = User.userData.home {
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.loadWeatherForPlace(home, atIndexPath: indexPath)
        }
        if let work = User.userData.work {
            let indexPath = NSIndexPath(forRow: 1, inSection: 0)
            self.loadWeatherForPlace(work, atIndexPath: indexPath)
        }
        for (i, place) in User.userData.otherPlaces.enumerate() {
            let indexPath = NSIndexPath(forRow: i, inSection: 1)
            self.loadWeatherForPlace(place, atIndexPath: indexPath)
        }
    }
    
    // MARK: - API Calls
    
    func loadWeatherForPlace(place: Place, atIndexPath indexPath: NSIndexPath, withCompletion completionHandler: (() -> ())? = nil) {
        ForecastIOClient.sharedInstance.forecast(place.lat, longitude: place.lng) { (forecast, forecastAPICalls) -> Void in
            let currentTemperature = Int(round(forecast.currently!.temperature!))
            self.temperaturesByUUID[place.uuid] = currentTemperature
            print("\(1000 - forecastAPICalls!) API calls left today")
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
    }
    
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TodayViewCell.reuseIdentifier) as! TodayViewCell
        var placeType: PlaceType?
        var place: Place?
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.accessoryType = .None
        if indexPath.section == 0 {
            // Home/work places
            if indexPath.row == 0 {
                placeType = PlaceType.Home
                place = User.userData.home
                if place == nil {
                    cell.selectionStyle = .Default
                    cell.accessoryType = .DisclosureIndicator
                }
            } else {
                placeType = PlaceType.Work
                place = User.userData.work
                if place == nil {
                    cell.selectionStyle = .Default
                    cell.accessoryType = .DisclosureIndicator
                }
            }
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            placeType = PlaceType.Other
            place = User.userData.otherPlaces[indexPath.row]
        }
        cell.data = [
            "placeType": placeType,
            "place": place,
            "temperature": place != nil ? temperaturesByUUID[place!.uuid] : nil
        ]
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // Home/work
            return 2
        } else {
            // Other places
            return User.userData.otherPlaces.count
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
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! TodayViewCell
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if indexPath.section == 0 && cell.place != nil {
                if indexPath.row == 0 {
                    // Home
                    User.userData.editHome(nil)
                } else {
                    // Work
                    User.userData.editWork(nil)
                }
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            } else if indexPath.section == 1 {
                User.userData.removeOtherPlace(cell.place!.uuid)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.tableViewCellIsEmptyHomeOrWork(indexPath) == true {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! TodayViewCell
            let vc = PlaceLookupViewController.instantiateFromStoryboardForPushSegue(self, toSelectPlaceType: cell.placeType)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return self.tableViewCellIsEmptyHomeOrWork(indexPath) ? indexPath : nil
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: - Table helpers
    
    func tableViewCellIsEmptyHomeOrWork(indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 {
            if indexPath.row == 0 && User.userData.home == nil {
                return true
            } else if indexPath.row == 1 && User.userData.work == nil {
                return true
            }
        }
        return false
    }
    
    // MARK: - Button Actions
    
    @IBAction func onAddPlace(sender: UIBarButtonItem) {
        let vc = PlaceLookupViewController.instantiateFromStoryboardForModalSegue(self, toSelectPlaceType: PlaceType.Other)
        presentViewController(vc, animated: true, completion: nil)
    }

    // MARK: - PlaceLookupViewControllerDelegate
    func placeLookupViewController(placeLookupViewController: PlaceLookupViewController, didSelectPlace selectedPlace: Place) {
        if let placeType = selectedPlace.placeType {
            switch placeType {
            case .Home:
                User.userData.editHome(selectedPlace)
            case .Work:
                User.userData.editWork(selectedPlace)
            case .Other:
                User.userData.addOtherPlace(selectedPlace)
            }
            self.tableView.reloadData()
        }
    }
}
