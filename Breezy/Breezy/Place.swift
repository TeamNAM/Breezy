//
//  Place.swift
//  Breezy
//
//  Created by Anvisha Pai on 10/18/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import Foundation
import UIKit
import ForecastIOClient

let UUID_KEY = "uuid"
let LAT_KEY = "lat"
let LNG_KEY = "lng"
let ADDRESS_KEY = "formattedAddress"
let NAME_KEY = "name"
let PLACE_ID_KEY = "placeId"
let REC_ICON_KEY = "recommendationIcon"
let REC_MSG_KEY = "recommendationMessage"
let DET_MSG_KEY = "detailedMessage"

class Place : NSObject, NSCoding{
    let uuid: String!
    var lat: Double
    var lng: Double
    var name: String
    var formattedAddress: String
    var placeId: Int?
    var recommendationIcon: UIImage?
    var recommendationMessage: String?
    var detailedMessage: String?
    
    init(lat: Double, lng: Double, name: String, formattedAddress: String, recommendationIcon: UIImage?, recommendationMessage: String?, detailedMessage: String?) {
        self.uuid = NSUUID().UUIDString
        self.lat = lat
        self.lng = lng
        self.name = name
        self.formattedAddress = formattedAddress
        if let recommendationIcon = recommendationIcon {
            self.recommendationIcon = recommendationIcon
        }
        if let recommendationMessage = recommendationMessage {
            self.recommendationMessage = recommendationMessage
        }
        if let detailedMessage = detailedMessage {
            self.detailedMessage = detailedMessage
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.uuid = aDecoder.decodeObjectForKey(UUID_KEY) as! String
        self.lat = aDecoder.decodeObjectForKey(LAT_KEY) as! Double
        self.lng = aDecoder.decodeObjectForKey(LNG_KEY) as! Double
        self.name = aDecoder.decodeObjectForKey(NAME_KEY) as! String
        self.formattedAddress = aDecoder.decodeObjectForKey(ADDRESS_KEY) as! String
        self.placeId = aDecoder.decodeObjectForKey(PLACE_ID_KEY) as? Int
        self.recommendationMessage = aDecoder.decodeObjectForKey(REC_MSG_KEY) as? String
        self.detailedMessage = aDecoder.decodeObjectForKey(DET_MSG_KEY) as? String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.uuid, forKey: UUID_KEY)
        aCoder.encodeObject(self.lat, forKey: LAT_KEY)
        aCoder.encodeObject(self.lng, forKey: LNG_KEY)
        aCoder.encodeObject(self.name, forKey: NAME_KEY)
        aCoder.encodeObject(self.formattedAddress, forKey: ADDRESS_KEY)
        aCoder.encodeObject(self.placeId, forKey: PLACE_ID_KEY)
        aCoder.encodeObject(self.recommendationIcon, forKey: REC_ICON_KEY)
        aCoder.encodeObject(self.recommendationMessage, forKey: REC_MSG_KEY)
        aCoder.encodeObject(self.detailedMessage, forKey: DET_MSG_KEY)
    }
    
    func suggestionsForDataPoint(dataPoint: DataPoint) -> [Suggestion] {
        var suggestions = [Suggestion]()
        //Temperature
        let temp = dataPoint.temperature!
        switch temp {
            case 0..<40:
                suggestions.append(Suggestion(name: "freezing"))
            case 40..<60:
                suggestions.append(Suggestion(name: "cold"))
            case 60..<65:
                suggestions.append(Suggestion(name: "chilly"))
            case 80..<85:
                suggestions.append(Suggestion(name: "warm"))
            case 85...200:
                suggestions.append(Suggestion(name: "hot"))
            default:
                print("No temperature warnings added")
        }
        
        //Precip
        if let precip = dataPoint.precipType {
            switch precip {
                case .Rain:
                    suggestions.append(Suggestion(name: "rain"))
                case .Hail:
                    suggestions.append(Suggestion(name: "hail"))
                case .Sleet:
                    suggestions.append(Suggestion(name: "sleet"))
                case .Snow:
                    suggestions.append(Suggestion(name: "snow"))
            }
        }
        return suggestions
    }
    
    //Put in an array of data points of hourly data.
    func suggestionsForHourlyDataPoints(dataPoints: [DataPoint]) -> [Suggestion] {
        var suggestions = [Suggestion]()
        for dataPoint in dataPoints {
            let sugg = suggestionsForDataPoint(dataPoint)
            for s in sugg {
                if  suggestions.filter({ el in el.name == s.name}).count > 0{
                    //do nothing
                } else {
                    suggestions.append(s)
                }
            }
        }
        return suggestions
    }
}