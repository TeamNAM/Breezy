//
//  Trip.swift
//  Breezy
//
//  Created by Anvisha Pai on 10/21/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import Foundation

let START_KEY = "startDate"
let END_KEY = "endDate"
let PLACE_KEY = "place"

class Trip : NSObject, NSCoding {
    var startDate: NSDate?
    var endDate: NSDate?
    var place: Place?
    var name: String?
    
    init(startDate: NSDate, endDate: NSDate, place: Place, name: String?){
        self.startDate = startDate
        self.endDate = endDate
        self.place = place
        if let name = name {
            self.name = name
        }
    }
    
    required init?(coder aDecoder: NSCoder){
        self.startDate = aDecoder.decodeObjectForKey(START_KEY) as? NSDate
        self.endDate = aDecoder.decodeObjectForKey(END_KEY) as? NSDate
        self.place = aDecoder.decodeObjectForKey(PLACE_KEY) as? Place
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.startDate, forKey: START_KEY)
        aCoder.encodeObject(self.endDate, forKey: END_KEY)
        aCoder.encodeObject(self.place, forKey: PLACE_KEY)
    }
    
    
}