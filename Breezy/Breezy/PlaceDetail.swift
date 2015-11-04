//
//  Place.swift
//  Breezy
//
//  Created by Anvisha Pai on 10/18/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import Foundation

class PlaceDetail : NSObject{
    var name: String?
    var photos: [GooglePhoto]?
//    var addressComponents: [NSDictionary]
    var types: String?

    
    init(dictionary: NSDictionary) {
        super.init()
        if let name = dictionary["name"] as? String {
            self.name = name
        }
//        print(dictionary)
        if let photos = dictionary["photos"] as? [NSDictionary]{
            let googlePhotos = GooglePhoto.getPhotosFromArray(photos)
            self.photos = googlePhotos
        }
    }
    
    func getFirstPhotoRef() -> String? {
        if let photos = self.photos {
            print("number of photos found \(photos.count)")
            return photos.first?.photoReference
        }
        return ""
    }
    
}
