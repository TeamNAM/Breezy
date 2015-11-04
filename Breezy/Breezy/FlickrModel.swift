//
//  GooglePhoto.swift
//  Breezy
//
//  Created by Matthew Goo on 11/3/15.
//  Copyright © 2015 TeamNAM. All rights reserved.


import Foundation

class FlickrPhoto : NSObject{
    var owner: Int?
    var secret: Int?
    var id: Int?
    var title: String?

    
    init(dictionary: NSDictionary) {
        super.init()
        if let owner = dictionary["owner"] as? Int {
            self.owner = owner
        }
        if let secret = dictionary["secret"] as? Int {
            self.secret = secret
        }
        if let id = dictionary["id"] as? Int {
            self.id = id
        }
        if let title = dictionary["title"] as? String {
            self.title = title
        }
    }
    
    static func getPhotosFromArray(photos: [NSDictionary]) -> [FlickrPhoto] {
        var flickrPhotos = [FlickrPhoto]()
        for photo in photos {
            flickrPhotos.append(FlickrPhoto(dictionary: photo))
        }
        
        return flickrPhotos
    }
    
}