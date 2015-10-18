//
//  Place.swift
//  Breezy
//
//  Created by Anvisha Pai on 10/18/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import Foundation

enum PlaceType {
    case Home
    case Work
    case Other
}

class Place:NSObject {
    
    var latitude:Double?
    var longitude:Double?
    var addressDescription:String?
    var placeType: PlaceType?
    
    init(dictionary: NSDictionary) {
    }
}