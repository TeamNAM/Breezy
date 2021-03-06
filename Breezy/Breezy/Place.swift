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
let PHOTO_URL_KEY = "photoUrl"

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
    var photoUrl: NSURL?
    
    init(lat: Double, lng: Double, name: String, formattedAddress: String, recommendationIcon: UIImage?, recommendationMessage: String?, detailedMessage: String?, photoUrl: NSURL?) {
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
        if let photoUrl = photoUrl {
            self.photoUrl = photoUrl
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
        self.photoUrl = aDecoder.decodeObjectForKey(PHOTO_URL_KEY) as? NSURL
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
        aCoder.encodeObject(self.photoUrl, forKey: PHOTO_URL_KEY)
    }
}