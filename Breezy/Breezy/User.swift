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
    var other: [Place]?
    var trips: [Trip]?
    
    override init(){
        self.home = nil
        self.work = nil
        self.other = [Place]()
        self.trips = [Trip]()
        
    }
    
    required init?(coder aDecoder: NSCoder){
        self.home = aDecoder.decodeObjectForKey(HOME_KEY) as? Place
        self.work = aDecoder.decodeObjectForKey(WORK_KEY) as? Place
        self.other = aDecoder.decodeObjectForKey(OTHER_KEY) as? [Place]
        self.trips = aDecoder.decodeObjectForKey(TRIPS_KEY) as? [Trip]
        super.init()
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.home, forKey: HOME_KEY)
        aCoder.encodeObject(self.work, forKey: WORK_KEY)
        aCoder.encodeObject(self.other, forKey: OTHER_KEY)
        aCoder.encodeObject(self.trips, forKey: TRIPS_KEY)
    }
    
    func addOtherPlace(place: Place) {
        self.other?.append(place)
    }
    
    func removeOtherPlace(index: Int){
        self.other?.removeAtIndex(index)
    }
    
    func addTrip(trip: Trip){
        self.trips?.append(trip)
    }
    
    func removeTrip(index: Int){
        self.other?.removeAtIndex(index)
    }

    
    class var userData: User? {
        get {
            return _currentUser ?? User()
        }
    }
}