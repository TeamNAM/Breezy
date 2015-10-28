//
//  Place.swift
//  Breezy
//
//  Created by Anvisha Pai on 10/18/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import Foundation
import UIKit

//TODO(Anvisha): Remove PlaceType from the code.
enum PlaceType {
    case Home
    case Work
    case Other
    
    var description : String {
        switch self {
        case .Home: return "Home";
        case .Work: return "Work";
        case .Other: return "Other";
        }
    }
}
let LAT_KEY = "lat"
let LNG_KEY = "lng"
let ADDRESS_KEY = "addressDescription"
let PLACE_TYPE_KEY = "placeType"
let REC_ICON_KEY = "recommendationIcon"
let REC_MSG_KEY = "recommendationMessage"
let DET_MSG_KEY = "detailedMessage"

class Place : NSObject, NSCoding{
    var lat:Double?
    var lng:Double?
    var addressDescription:String?
    var placeType: PlaceType?
    var recommendationIcon: UIImage?
    var recommendationMessage: String?
    var detailedMessage: String?
    
    init(lat: Double, lng: Double, addressDescription: String, placeType: PlaceType?, recommendationIcon: UIImage?, recommendationMessage: String?, detailedMessage: String?) {
        self.lat = lat
        self.lng = lng
        self.addressDescription = addressDescription
        if let placeType = placeType {
            self.placeType = placeType
        }
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
    
    required init?(coder aDecoder: NSCoder){
        self.lat = aDecoder.decodeObjectForKey(LAT_KEY) as? Double
        self.lng = aDecoder.decodeObjectForKey(LNG_KEY) as? Double
        self.addressDescription = aDecoder.decodeObjectForKey(ADDRESS_KEY) as? String
        self.placeType = aDecoder.decodeObjectForKey(PLACE_TYPE_KEY) as? PlaceType
        self.recommendationIcon = aDecoder.decodeObjectForKey(REC_ICON_KEY) as? UIImage
        self.recommendationMessage = aDecoder.decodeObjectForKey(REC_MSG_KEY) as? String
        self.detailedMessage = aDecoder.decodeObjectForKey(DET_MSG_KEY) as? String
        super.init()
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.lat, forKey: LAT_KEY)
        aCoder.encodeObject(self.lng, forKey: LNG_KEY)
        aCoder.encodeObject(self.addressDescription, forKey: ADDRESS_KEY)
        aCoder.encodeObject(self.placeType as? AnyObject, forKey: PLACE_TYPE_KEY)
        aCoder.encodeObject(self.recommendationIcon, forKey: REC_ICON_KEY)
        aCoder.encodeObject(self.recommendationMessage, forKey: REC_MSG_KEY)
        aCoder.encodeObject(self.detailedMessage, forKey: DET_MSG_KEY)
    }
}