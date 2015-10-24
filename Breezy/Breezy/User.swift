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
let OTHER_PLACES_KEY = "otherPlaces"
let TRIPS_KEY = "trips"

class User : NSObject, NSCoding{
    
    private(set) var home: Place?
    private(set) var work: Place?
    var other: [Int: Place]?
    private(set) var otherPlaces: [Place]
    var trips: [Trip]?
    
    override init(){
        self.home = nil
        self.work = nil
        self.other = [Int: Place]()
        self.otherPlaces = [Place]()
        self.trips = [Trip]()
    }
    
    required init?(coder aDecoder: NSCoder){
        self.home = aDecoder.decodeObjectForKey(HOME_KEY) as? Place
        self.work = aDecoder.decodeObjectForKey(WORK_KEY) as? Place
        self.other = aDecoder.decodeObjectForKey(OTHER_KEY) as? [Int: Place]
        self.otherPlaces = aDecoder.decodeObjectForKey(OTHER_PLACES_KEY) as! [Place]
        self.trips = aDecoder.decodeObjectForKey(TRIPS_KEY) as? [Trip]
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.home, forKey: HOME_KEY)
        aCoder.encodeObject(self.work, forKey: WORK_KEY)
        aCoder.encodeObject(self.other, forKey: OTHER_KEY)
        aCoder.encodeObject(self.otherPlaces, forKey: OTHER_PLACES_KEY)
        aCoder.encodeObject(self.trips, forKey: TRIPS_KEY)
    }
    
    func editHome(place: Place?) {
        if let place = place {
            place.placeType = PlaceType.Home
        }
        self.home = place
    }

    func editWork(place: Place?) {
        if let place = place {
            place.placeType = PlaceType.Work
        }
        self.work = place
    }
    
    func addOtherPlace(place: Place) {
        self.otherPlaces.append(place)
    }
    
    func removeOtherPlace(placeUUID: String) {
        for i in 0...self.otherPlaces.count {
            let place = self.otherPlaces[i]
            if place.uuid == placeUUID {
                self.otherPlaces.removeAtIndex(i)
                break
            }
        }
    }
    
    func addTrip(trip: Trip){
        self.trips?.append(trip)
    }
    
    func removeTrip(index: Int){
        self.trips?.removeAtIndex(index)
    }

    static var sharedInstance: User {
        get {
            return _currentUser ?? User()
        }
    }
}