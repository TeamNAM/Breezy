//
//  Weather.swift
//  Breezy
//
//  Created by Matthew Goo on 10/25/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import Foundation

let ICON_KEY = "icon"
let PRECIP_PROB_KEY = "precipitationProbability"
let TEMP_KEY = "temp"

class Weather : NSObject, NSCoding {
    var icon: String?
    var precipProbability: Double?
    var temperature: Double?
    var time: NSDate?
    
    init(icon: String?, precipProb: Double?, temp: Double?, time: Int?){
        if let icon = icon {
            self.icon = icon
        }
        if let precipProb = precipProb {
            self.precipProbability = precipProb
        }
        if let temp = temp {
            self.temperature = temp
        }
    }
    
    required init?(coder aDecoder: NSCoder){
        self.icon = aDecoder.decodeObjectForKey(ICON_KEY) as? String
        self.precipProbability = aDecoder.decodeObjectForKey(PRECIP_PROB_KEY) as? Double
        self.temperature = aDecoder.decodeObjectForKey(TEMP_KEY) as? Double
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.icon, forKey: ICON_KEY)
        aCoder.encodeObject(self.precipProbability, forKey: PRECIP_PROB_KEY)
        aCoder.encodeObject(self.temperature, forKey: TEMP_KEY)
    }
}