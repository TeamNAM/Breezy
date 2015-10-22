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
class TodayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var todayWeatherTableView: UITableView!
    var places: [Place]?
    
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
