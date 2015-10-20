//
//  Helpers.swift
//  Breezy
//
//  Created by Matthew Goo on 10/18/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import Foundation
import GoogleMaps

class MapHelpers {
    static func placeAutocomplete(placesClient: GMSPlacesClient, query: String, completionHandler: (predictions: [GMSAutocompletePrediction]?, error: NSError?) -> ()) {
        let filter = GMSAutocompleteFilter()
        placesClient.autocompleteQuery(query, bounds: nil, filter: filter, callback: { (results, error: NSError?) -> Void in
            if let error = error {
                completionHandler(predictions: nil, error: error)
                print("Autocomplete error \(error)")
            } else {
                var predictions = [GMSAutocompletePrediction]()
                for result in results! {
                    if let result = result as? GMSAutocompletePrediction {
                        predictions.append(result)
                    }
                }
                print("got predictions for query \(query)")
                completionHandler(predictions: predictions, error: nil)
            }
        })
    }
    
    
    static func triggerCurrentLocation(locationManager: CLLocationManager?, delegate: CLLocationManagerDelegate) {
        if let locationManager = locationManager {
            locationManager.delegate = delegate;
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.distanceFilter = 500;
            if CLLocationManager.authorizationStatus() == .NotDetermined {
                locationManager.requestAlwaysAuthorization()
            }
            locationManager.startUpdatingLocation()
        }
    }
    
    static func setMap(map: GMSMapView, location: CLLocation) {
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        
        let camera = GMSCameraPosition.cameraWithLatitude(lat,
            longitude: long, zoom: 13)
        map.myLocationEnabled = true
        map.camera = camera
        
        //        let marker = GMSMarker()
        //        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
        //        marker.title = "Sydney"
        //        marker.snippet = "Australia"
        //        marker.map = map
    }
}