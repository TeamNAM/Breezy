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
}

class Place:NSObject {
    
    var lat:Double?
    var lng:Double?
    var addressDescription:String?
    var placeType: PlaceType?
    
    init(lat: Double, lng: Double, addressDescription: String) {
        self.lat = lat
        self.lng = lng
        self.addressDescription = addressDescription
    }
}