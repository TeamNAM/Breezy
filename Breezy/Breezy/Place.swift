//
//  Place.swift
//  Breezy
//
//  Created by Anvisha Pai on 10/18/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import Foundation

let LAT_KEY = "lat"
let LNG_KEY = "lng"
let ADDRESS_KEY = "addressDescription"

class Place : NSObject, NSCoding{
    var lat:Double?
    var lng:Double?
    var addressDescription:String?
    
    init(lat: Double, lng: Double, addressDescription: String) {
        self.lat = lat
        self.lng = lng
        self.addressDescription = addressDescription
    }
    
    required init?(coder aDecoder: NSCoder){
        self.lat = aDecoder.decodeObjectForKey(LAT_KEY) as? Double
        self.lng = aDecoder.decodeObjectForKey(LNG_KEY) as? Double
        self.addressDescription = aDecoder.decodeObjectForKey(ADDRESS_KEY) as? String
        super.init()
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.lat, forKey: LAT_KEY)
        aCoder.encodeObject(self.lng, forKey: LNG_KEY)
        aCoder.encodeObject(self.addressDescription, forKey: ADDRESS_KEY)
    }
}