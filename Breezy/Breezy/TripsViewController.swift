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
                trip.loadForecast() {
                    self.tripTableView.reloadData()
                }
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
        tripTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tripTableView.estimatedRowHeight = 120
        tripTableView.reloadData()
    }
    
    private func setupBackgroundView() {
        //        let gradient: CAGradientLayer = CAGradientLayer()
        //        gradient.frame = view.bounds
        //
        //        let blue = UIColor(red: 141/255, green: 204/255, blue: 229/255, alpha: 1)
        //        let tan = UIColor(red: 223/255, green: 207/255, blue: 186/255, alpha: 1)
        //        gradient.colors = [blue.CGColor, tan.CGColor]
        //        backgroundView.layer.insertSublayer(gradient, atIndex: 0)
        let color = UIColor(red: 115/255, green: 183/255, blue: 230/255, alpha: 1)
        
        backgroundView.backgroundColor = color
    }
    
    @IBAction func didTapAddNewTrip(sender: UIBarButtonItem) {
        addNewTrip()
    }
    
    // MARK: - Table View
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let trips = User.sharedInstance.trips {
            if trips.count == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("AddTripCell", forIndexPath:indexPath)
                return cell
            } else {
                let trip = trips[indexPath.section]
                
                if trip.hasLoadedForecast == true {
                    let cell = tableView.dequeueReusableCellWithIdentifier("TripCell", forIndexPath: indexPath) as! TripCell
                    
                    cell.trip = trip
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCellWithIdentifier("LoadingCell", forIndexPath: indexPath) as! LoadingCell
                    return cell
                }
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
        } else if cell is LoadingCell {
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
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
        
        if cell is TripCell {
            let tripCell = (cell as! TripCell)
            let imageUrl = tripCell.trip.place?.photoUrl
            let color = ColorPalette.getAverageColorForTemp(tripCell.trip.averageTemp!)
            print(imageUrl)
            
            if let imageUrl = imageUrl {
                if let data = NSData(contentsOfURL: imageUrl){
                    let imageView = UIImageView()
                    imageView.contentMode = UIViewContentMode.ScaleAspectFit
                    imageView.image = UIImage(data: data)
                    CellHelpers.drawCellBackground(cell, fillColor: color, backgroundImage: imageView.image)
                } else {
                    CellHelpers.drawCellBackground(cell, fillColor: color, backgroundImage: nil)
                }
            } else {
                let fakeBg = UIImage(named: "sunbg")!
                CellHelpers.drawCellBackground(cell, fillColor: color, backgroundImage: fakeBg)
            }
        } else {
            cell.contentView.backgroundColor = UIColor.clearColor()
            CellHelpers.drawCellBackground(cell, fillColor: ColorPalette.blue, backgroundImage: nil)
        }
    }
    
    // MARK: - Trip detail view
    
    private func goToTripDetailView(cell: TripCell) {
        let vc = MultiDayViewController.instantiateFromStoryboard() as! MultiDayViewController
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
        self.tripTableView.reloadData()
        
        trip.loadForecast() {
            self.tripTableView.reloadData()
        }
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
    let place1 = Place(lat: 32, lng: 121, name: "Mexico", formattedAddress: "707 Mexico", recommendationIcon: nil, recommendationMessage: nil, detailedMessage: nil, photoUrl: nil)
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
