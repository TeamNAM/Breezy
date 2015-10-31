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
    private let ROW_HEIGHT: CGFloat = 120.0
    private var indexPathToCellFillColor = [NSIndexPath: UIColor]()
    private var indexPathToCellForecast = [NSIndexPath: Forecast]()
    private var indexPathToPlace = [NSIndexPath: Place]()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.navigationController?.delegate = AppDelegate.sharedDelegate().navigationDelegate
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = ROW_HEIGHT
        tableView.allowsMultipleSelectionDuringEditing = false
        let todayViewCellNib = UINib(nibName: TodayViewCell.reuseIdentifier, bundle: NSBundle.mainBundle())
        tableView.registerNib(todayViewCellNib, forCellReuseIdentifier: TodayViewCell.reuseIdentifier)
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        if let home = User.sharedInstance.home {
            self.loadWeatherForPlace(home, forCellAtIndexPath: self.homeIndexPath)
        }
        if let work = User.sharedInstance.work {
            self.loadWeatherForPlace(work, forCellAtIndexPath: self.workIndexPath)
        }
        for (i, place) in User.sharedInstance.otherPlaces.enumerate() {
            let indexPath = NSIndexPath(forRow: i, inSection: 1)
            self.loadWeatherForPlace(place, forCellAtIndexPath: indexPath)
        }
    }
    
    // MARK: - API Calls
    
    func loadWeatherForPlace(place: Place, forCellAtIndexPath indexPath: NSIndexPath) {
        TodayForecastCache.fetchForecastForPlace(place) { (forecast: Forecast) -> Void in
            self.indexPathToCellForecast[indexPath] = forecast
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
        cell.placeType = placeType
        if let place = place {
            indexPathToPlace[indexPath] = place
            cell.place = place
            if let forecast = TodayForecastCache.forecastForPlace(place) {
                indexPathToCellForecast[indexPath] = forecast
                cell.forecast = forecast
            } else {
                indexPathToCellForecast.removeValueForKey(indexPath)
            }
        } else {
            indexPathToPlace.removeValueForKey(indexPath)
        }
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
        guard let place = indexPathToPlace[indexPath] else {
            // A home or work cell without a work address
            let placeType = self.getPlaceTypeForIndexPath(indexPath)
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
                    self.loadWeatherForPlace(selectedPlace, forCellAtIndexPath: indexPath)
                })
                self.navigationController?.popViewControllerAnimated(true)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            return
        }

        let vc = DailyWeatherDetailViewController.instantiateFromStoryboard()
        vc.place = place
        vc.forecast = TodayForecastCache.forecastForPlace(place)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func drawCellBackground(cell: UITableViewCell, fillColor: UIColor) -> Void {
        let cellMargin: CGFloat = 4.0
        let fillColorRect = CGRect(x: cell.bounds.origin.x + cellMargin, y: cell.bounds.origin.y + cellMargin, width: cell.bounds.width - (cellMargin * 2), height: cell.bounds.height - cellMargin)
        let fillColorView = UIView(frame: fillColorRect)
        fillColorView.backgroundColor = fillColor
        fillColorView.layer.cornerRadius = 10
        let bgView = UIView(frame: cell.frame)
        bgView.addSubview(fillColorView)
        cell.backgroundView = bgView
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let _ = indexPathToPlace[indexPath] else {
            self.drawCellBackground(cell, fillColor: UIColor(red: 52/255.0, green: 61/255.0, blue: 70/255.0, alpha: 1.0)
)
            return
        }
        guard let forecast = indexPathToCellForecast[indexPath] else {
            return
        }
        let temperature = forecast.currently?.temperature as Double!
        let fillColor = ColorPalette.getAverageColorForTemp(temperature)
        guard indexPathToCellFillColor[indexPath] != fillColor else {
            return
        }

        self.drawCellBackground(cell, fillColor: fillColor)
    }
    


    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ROW_HEIGHT
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
                self.loadWeatherForPlace(selectedPlace, forCellAtIndexPath: indexPath)
            })
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let navVC = UINavigationController(rootViewController: vc)
        self.presentViewController(navVC, animated: true, completion: nil)
    }
}
