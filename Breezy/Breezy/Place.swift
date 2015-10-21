//
//  Place.swift
//  Breezy
//
//  Created by Anvisha Pai on 10/18/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import Foundation
import UIKit
import CoreData

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

class Place:NSObject {
    
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
}