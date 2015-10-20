//
//  NewTripViewController.swift
//  Breezy
//
//  Created by Matthew Goo on 10/16/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit
import GoogleMaps

class NewTripViewController: UIViewController, CLLocationManagerDelegate, UISearchResultsUpdating {

    @IBOutlet weak var googleMapView: GMSMapView!
    var locationManager: CLLocationManager?
    var searchController: UISearchController!
    var debounceTimer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        //        addCurrentLocationButton()
        addSearch()
        
        MapHelpers.triggerCurrentLocation(locationManager, delegate: self)
        
        
    }
    
    func addSearch() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.navigationItem.titleView = searchController.searchBar
    }
    
    func addCurrentLocationButton() {
        let button = UIImageView(image: UIImage(named: "location"))
        let views = ["button": button, "googleMapView": googleMapView]
        googleMapView.addSubview(button)
//        button.frame.height = 50
//        button.frame.width = 50

        
        button.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|[button]-50-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views)
        let verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|[button]-50-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views)
        googleMapView.addConstraints(verticalConstraint)
        googleMapView.addConstraints(horizontalConstraint)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            let trimmedText = searchText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if trimmedText.characters.count > 0 {
                if let timer = debounceTimer {
                    timer.invalidate()
                }
                debounceTimer = NSTimer(timeInterval: 0.25, target: self, selector: Selector("callAutoCompleteAndLoadMap:"), userInfo: trimmedText, repeats: false)
                NSRunLoop.currentRunLoop().addTimer(debounceTimer!, forMode: "NSDefaultRunLoopMode")
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lat = locations[0].coordinate.latitude
        let long = locations[0].coordinate.longitude
        print("lat \(lat) long \(long)")
        MapHelpers.setMap(googleMapView, location: locations[0])
        locationManager!.stopUpdatingLocation()
    }
    
//    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
//        print("Error while updating location " + error.localizedDescription)
//    }


    /*x
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
