//
//  User.swift
//  Breezy
//
//  Created by Anvisha Pai on 10/18/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import Foundation

var _currentUser: User?
let HOME_KEY = "home"
let WORK_KEY = "work"
let OTHER_KEY = "other"
let TRIPS_KEY = "trips"

class User : NSObject, NSCoding{
    
    var home: Place?
    var work: Place?
    var other: [String: Place]?
    var trips: [Trip]?
    
    override init(){
        self.home = nil
        self.work = nil
        self.other = [String: Place]()
        self.trips = [Trip]()
    }
    
    required init?(coder aDecoder: NSCoder){
        self.home = aDecoder.decodeObjectForKey(HOME_KEY) as? Place
        self.work = aDecoder.decodeObjectForKey(WORK_KEY) as? Place
        self.other = aDecoder.decodeObjectForKey(OTHER_KEY) as? [String: Place]
        self.trips = aDecoder.decodeObjectForKey(TRIPS_KEY) as? [Trip]
        super.init()
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.home, forKey: HOME_KEY)
        aCoder.encodeObject(self.work, forKey: WORK_KEY)
        aCoder.encodeObject(self.other, forKey: OTHER_KEY)
        aCoder.encodeObject(self.trips, forKey: TRIPS_KEY)
    }
    
    func addHome(place: Place) {
        place.placeType = PlaceType.Home
        self.home = place
    }
    
    func removeHome() {
        self.home = nil
    }
    
    func addWork(place: Place) {
        place.placeType = PlaceType.Work
        self.work = place
    }
    
    func removeWork() {
        self.work = nil
    }
    
    func addOtherPlace(place: Place) {
        let placeId = NSUUID().UUIDString
        place.placeType = PlaceType.Other
        self.other?[placeId] = place
    }
    
    func removeOtherPlace(placeId: String){
        self.other?.removeValueForKey(placeId)
    }
    
    func addTrip(trip: Trip){
        self.trips?.append(trip)
    }
    
    func removeTrip(index: Int){
        self.trips?.removeAtIndex(index)
    }

    class var userData: User? {
        get {
            return _currentUser ?? User()
        }
    }
}