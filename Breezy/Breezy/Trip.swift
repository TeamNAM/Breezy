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
    var weather: [Weather] = [Weather]()
    
    init(startDate: NSDate, endDate: NSDate, place: Place, name: String?){
        self.startDate = startDate
        self.endDate = endDate
        self.place = place
        if let name = name {
            place.name = name
        }
    }
    
//    func setWeatherData(icon: ) {
//        let weatherDay = weather[i]
//        var icon: String?
//        var precipProb: Double?
//        var temp: Double?
//        
//        if let iconString = weatherDay["icon"] {
//            icon = iconString as? String
//        }
//        if let precipProbDouble = weatherDay["precipProbability"] {
//            precipProb = precipProbDouble as? Double
//        }
//        if let temperatureDouble = weatherDay["temperature"] {
//            temp = temperatureDouble as? Double
//        }
//        
//        self.weather.append(Weather(icon: icon, precipProb: precipProb, temp: temp))
//    }
    
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