//
//  TodayViewController.swift
//  Breezy
//
//  Created by Matthew Goo on 10/20/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PlaceLookupViewDelegate {
    
    // MARK: - Static initializer
    
    static func instantiateFromStoryboard() -> UIViewController {
        return UIStoryboard(name: storyboardID, bundle: nil).instantiateViewControllerWithIdentifier(storyboardID)
    }
    
    // MARK: - Properties
    
    static let storyboardID = "TodayViewController"

    @IBOutlet weak var todayWeatherTableView: UITableView!
    var places = [Place]()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.places = User.userData!.getOtherPlaces()
        
        todayWeatherTableView.delegate = self
        todayWeatherTableView.dataSource = self
        let todayViewCellNib = UINib(nibName: TodayViewCell.reuseIdentifier, bundle: NSBundle.mainBundle())
        todayWeatherTableView.registerNib(todayViewCellNib, forCellReuseIdentifier: TodayViewCell.reuseIdentifier)
        todayWeatherTableView.rowHeight = UITableViewAutomaticDimension
        todayWeatherTableView.estimatedRowHeight = 50
        todayWeatherTableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("Section \(indexPath.section)")
        print("Row \(indexPath.row)")
        let cell = tableView.dequeueReusableCellWithIdentifier(TodayViewCell.reuseIdentifier) as! TodayViewCell
        var placeType: PlaceType?
        var place: Place?
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if indexPath.section == 0 {
            // Home/work places
            if indexPath.row == 0 {
                placeType = PlaceType.Home
                place = User.userData?.home
                print(User.userData?.home?.name)
                if place == nil {
                    cell.selectionStyle = .Default
                }
            } else {
                placeType = PlaceType.Work
                place = User.userData?.work
                if place == nil {
                    cell.selectionStyle = .Default
                }
            }
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            placeType = PlaceType.Other
            place = self.places[indexPath.row]
            print(place?.placeId)
        }
        cell.data = ["placeType": placeType, "place": place]
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // Home/work
            return 2
        } else {
            // Other places
            return self.places.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Section 0 is home/work cells. Section 1 is "other places" cells
        return 2
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 0 && (todayWeatherTableView.cellForRowAtIndexPath(indexPath) as! TodayViewCell).place == nil {
            return indexPath
        } else {
            return nil
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func onAddPlace(sender: UIBarButtonItem) {
        let vc = PlaceLookupViewController.instantiateFromStoryboard(self, toSelectPlaceType: PlaceType.Other)
        presentViewController(vc, animated: true, completion: nil)
    }

    // MARK: - PlaceLookupViewControllerDelegate
    func placeLookupViewController(placeLookupViewController: PlaceLookupViewController, didSelectPlace selectedPlace: Place) {
        if let placeType = selectedPlace.placeType {
            switch placeType {
            case .Other:
                User.userData?.addOtherPlace(selectedPlace)
                self.places = User.userData!.getOtherPlaces()
                self.todayWeatherTableView.reloadData()
            default: ()
            }
        }
    }
}
