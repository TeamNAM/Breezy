//
//  TodayViewController.swift
//  Breezy
//
//  Created by Matthew Goo on 10/20/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit
let fakePlaces = [
    Place(lat: 31.32, lng: 124.432, name: "Nantucket", formattedAddress: "Nantucket, MA, US", placeType: .Home, recommendationIcon: UIImage(named: "airplane"), recommendationMessage: "Wear some shorts!", detailedMessage: "Its gonna be real hot"),
    Place(lat: 31.32, lng: 124.432, name: "Roanoke", formattedAddress: "Roanoke, VA, US", placeType: .Work, recommendationIcon: UIImage(named: "plus"), recommendationMessage: "Bring a sweater.", detailedMessage: "It'll be cold when you go home.")
]
class TodayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PlaceLookupViewDelegate {
    
    // MARK: - Static initializer
    
    static func instantiateFromStoryboard() -> UIViewController {
        return UIStoryboard(name: storyboardID, bundle: nil).instantiateViewControllerWithIdentifier(storyboardID)
    }
    
    // MARK: - Properties
    
    static let storyboardID = "TodayViewController"

    @IBOutlet weak var todayWeatherTableView: UITableView!
    var places: [Place]?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addWeatherCellNib = UINib(nibName: "WeatherCell", bundle: NSBundle.mainBundle())
        places = fakePlaces
        
        todayWeatherTableView.delegate = self
        todayWeatherTableView.dataSource = self
        
        todayWeatherTableView.registerNib(addWeatherCellNib, forCellReuseIdentifier: "WeatherCell")
        todayWeatherTableView.rowHeight = UITableViewAutomaticDimension
        todayWeatherTableView.estimatedRowHeight = 200
        todayWeatherTableView.reloadData()
        
    }
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WeatherCell") as! WeatherCell
        cell.place = places![indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let places = places {
            return places.count
        }
        return 0
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Button Actions
    
    @IBAction func onAddPlace(sender: UIBarButtonItem) {
        let vc = PlaceLookupViewController.instantiateFromStoryboard(self)
        presentViewController(vc, animated: true, completion: nil)
    }

    // MARK: - PlaceLookupViewControllerDelegate
    func placeLookupViewController(placeLookupViewController: PlaceLookupViewController, didSelectPlace selectedPlace: Place) {
        print(selectedPlace.name)
    }
}
