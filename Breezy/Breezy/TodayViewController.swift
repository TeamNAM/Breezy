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

    @IBOutlet weak var tableView: UITableView!
    
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
                place = User.userData.home
                if place == nil {
                    cell.selectionStyle = .Default
                }
            } else {
                placeType = PlaceType.Work
                place = User.userData.work
                if place == nil {
                    cell.selectionStyle = .Default
                }
            }
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            placeType = PlaceType.Other
            place = User.userData.otherPlaces[indexPath.row]
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
            return User.userData.otherPlaces.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Section 0 is home/work cells. Section 1 is "other places" cells
        return 2
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if indexPath.section == 1 {
                let place = User.userData.otherPlaces[indexPath.row]
                User.userData.removeOtherPlace(place.uuid)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableViewCellCanBeSelected(indexPath) == true {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! TodayViewCell
            let vc = PlaceLookupViewController.instantiateFromStoryboardForPushSegue(self, toSelectPlaceType: cell.placeType)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if tableViewCellCanBeSelected(indexPath) == true {
            return indexPath
        } else {
            return nil
        }
    }
    
    // MARK: - Table helpers
    
    func tableViewCellCanBeSelected(indexPath: NSIndexPath) -> Bool {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! TodayViewCell
        return indexPath.section == 0 && cell.place == nil
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
