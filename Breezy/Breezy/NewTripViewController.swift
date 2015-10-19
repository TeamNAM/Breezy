//
//  NewTripViewController.swift
//  Breezy
//
//  Created by Matthew Goo on 10/16/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit
import GoogleMaps

class NewTripViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var googleMapView: GMSMapView!
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        let camera = GMSCameraPosition.cameraWithLatitude(-33.86,
            longitude: 151.20, zoom: 6)
        googleMapView.myLocationEnabled = true
        googleMapView.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = googleMapView
        MapHelpers.getCurrentLocation(locationManager, delegate: self)
    }
    
    @IBAction func findLocation(sender: UIButton) {
        MapHelpers.getCurrentLocation(locationManager, delegate:  self)
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.count)
        print(locations[0].coordinate.latitude)
        print(locations[0].coordinate.longitude)
        print("test")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }


    /*x
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
