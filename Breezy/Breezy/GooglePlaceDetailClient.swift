//
//  GooglePlaceDetailClient.swift
//  Breezy
//
//  Created by Matthew Goo on 11/3/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import Foundation

class GooglePlaceDetailClient: NSObject {
    let apiKey = Credentials.defaultCredentials.placeDetailKey
    
    func getPlaceDetails(placeId: String, completion: ((placeDetail: PlaceDetail?, error: NSError?) -> Void)) {
        let baseUrl =
        "https://maps.googleapis.com/maps/api/place/details/json"
        let params = "placeid=\(placeId)&key=\(apiKey)"
        
        let url = "\(baseUrl)?\(params)"
        let nsUrl = NSURL(string: url)
        let request = NSURLRequest(URL: nsUrl!)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if error != nil {
                completion(placeDetail: nil, error: error)
            } else {
                let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary

                let result = json["result"] as! NSDictionary
                let placeDetail = PlaceDetail(dictionary: result)
                completion(placeDetail: placeDetail, error: nil)

            }
        }
        
        task.resume()
        
    }

    func getPhotoFromRef(photoRef: String) -> NSURL? {
        let maxWidth = 1000
        let apiKey = Credentials.defaultCredentials.placeDetailKey
        let baseUrl =
        "https://maps.googleapis.com/maps/api/place/photo"
        let params = "maxwidth=\(maxWidth)&photoreference=\(photoRef)&key=\(apiKey)"
        
        let url = "\(baseUrl)?\(params)"
        let nsUrl = NSURL(string: url)
        
        return nsUrl
    }

    func getPhotoFromPlaceId(placeId: String, completion: ((photoUrl: NSURL?, error: NSError?) -> Void)) {
        getPlaceDetails(placeId) { (placeDetail, error) -> Void in
            if error != nil {
                completion(photoUrl: nil, error: error)
            } else {
                
                let photoRef = placeDetail!.getFirstPhotoRef()
                if let photoRef = photoRef {
                    let photoUrl = self.getPhotoFromRef(photoRef)
                    completion(photoUrl: photoUrl, error: nil)
                }
            }
        }
    }
}