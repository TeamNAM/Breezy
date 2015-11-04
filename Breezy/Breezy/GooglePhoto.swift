//
//  GooglePhoto.swift
//  Breezy
//
//  Created by Matthew Goo on 11/3/15.
//  Copyright © 2015 TeamNAM. All rights reserved.


import Foundation

class GooglePhoto : NSObject{
    
    var height: Int?
    var htmlAttributions: String?
    var photoReference: String?
    var width: Int?
    
    init(dictionary: NSDictionary) {
        super.init()
        if let height = dictionary["height"] as? Int {
            self.height = height
        }
        if let html = dictionary["html_attributions"] as? String {
            self.htmlAttributions = html
        }
        if let photoRef = dictionary["photo_reference"] as? String {
            self.photoReference = photoRef
        }
        if let width = dictionary["width"] as? Int {
            self.width = width
        }
    }
    
    static func getPhotosFromArray(photos: [NSDictionary]) -> [GooglePhoto] {
        var googlePhotos = [GooglePhoto]()
        for photo in photos {
            googlePhotos.append(GooglePhoto(dictionary: photo))
        }
        
        return googlePhotos
    }
    
}