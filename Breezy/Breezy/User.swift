//
//  User.swift
//  Breezy
//
//  Created by Anvisha Pai on 10/18/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import Foundation

class User{
    
    var home: NSDictionary?
    var work: NSDictionary?
    var otherPlaces: [NSDictionary]?
    var trips: [NSDictionary]?
    
    init(dict: NSDictionary){
        let places = dict["Places"] as! NSDictionary
        self.home = places["Home"] as? NSDictionary
        self.work = places["Work"] as? NSDictionary
        self.otherPlaces = (places["Other"] as? [NSDictionary]?)!
    }
    
    class var sharedInstance : User {
        struct Static {
            static let instance = User(dict: appData!)
        }
        return Static.instance
    }
    
    func setHome(lat: Double, lng: Double, addressDescription: String) {
        self.home = ["lat": lat, "lng": lng, "addressDescription": addressDescription]
        setPlaceForKey("Home", lat: lat, lng: lng, addressDescription: addressDescription)
    }
    
    func setWork(lat: Double, lng: Double, addressDescription: String) {
        self.work = ["lat": lat, "lng": lng, "addressDescription": addressDescription]
        setPlaceForKey("Work", lat: lat, lng: lng, addressDescription: addressDescription)
    }
    
    func addOther(lat: Double, lng: Double, addressDescription: String) {
        self.otherPlaces?.append(["lat": lat, "lng": lng, "addressDescription": addressDescription]
        )
        setPlaceForKey("Other", lat: lat, lng: lng, addressDescription: addressDescription)
    }
    
    func removeOther() {
        //TODO(Anvisha)
    }
    
    func setPlaceForKey(key: String, lat: Double, lng: Double, addressDescription: String) {
        let dict = ["lat": lat, "lng": lng, "addressDescription": addressDescription]
        var placesData = appData!["Places"]?.mutableCopy() as! NSMutableDictionary
        if key == "Other" {
            var otherPlaces = placesData["Other"] as! Array<NSDictionary>
            otherPlaces.append(dict)
            placesData.setValue(otherPlaces, forKey: "Other")
        } else {
            print(key)
            print(dict)
            placesData.setValue(dict, forKey: key)
        }
        appData?.setValue(placesData, forKey: "Places")
        print(appData)
    }
}