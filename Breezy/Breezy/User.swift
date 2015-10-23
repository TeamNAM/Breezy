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
let MAX_PLACE_ID = "maxPlaceId"

class User : NSObject, NSCoding{
    
    var home: Place?
    var work: Place?
    var other: [Int: Place]?
    var trips: [Trip]?
    private var maxPlaceId: Int?
    
    override init(){
        self.home = nil
        self.work = nil
        self.other = [Int: Place]()
        self.trips = [Trip]()
        self.maxPlaceId = nil
    }
    
    required init?(coder aDecoder: NSCoder){
        self.home = aDecoder.decodeObjectForKey(HOME_KEY) as? Place
        self.work = aDecoder.decodeObjectForKey(WORK_KEY) as? Place
        self.other = aDecoder.decodeObjectForKey(OTHER_KEY) as? [Int: Place]
        self.trips = aDecoder.decodeObjectForKey(TRIPS_KEY) as? [Trip]
        self.maxPlaceId = aDecoder.decodeObjectForKey(MAX_PLACE_ID) as? Int ?? 0
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.home, forKey: HOME_KEY)
        aCoder.encodeObject(self.work, forKey: WORK_KEY)
        aCoder.encodeObject(self.other, forKey: OTHER_KEY)
        aCoder.encodeObject(self.trips, forKey: TRIPS_KEY)
        aCoder.encodeObject(self.maxPlaceId, forKey: MAX_PLACE_ID)
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
    
    func getOtherPlaces() -> [Place] {
        var otherPlaces = [Place]()
        if let places = self.other {
            for key in Array(self.other!.keys).sort() {
                otherPlaces.append(places[key]!)
            }
        }
        return otherPlaces
    }
    
    func addOtherPlace(place: Place) {
        place.placeType = PlaceType.Other
        self.maxPlaceId! += 1
        place.placeId = self.maxPlaceId
        self.other?[self.maxPlaceId!] = place
    }
    
    func removeOtherPlace(placeId: Int){
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