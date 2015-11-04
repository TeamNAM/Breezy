//
//  Flickr.swift
//  Breezy
//
//  Created by Matthew Goo on 11/4/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import Foundation

class FlickrClient: NSObject {
    
    static func GetFlickrData(tags: String, completion: (photoUrl: String?, error: NSError?) -> Void) {
        let apiKey = Credentials.defaultCredentials.flickrApiKey
        let tags = "San Francisco"
        
        let baseURL = "https://api.flickr.com/services/rest/?&method=flickr.photos.search&format=json"
        let apiString = "&api_key=\(apiKey)"
        let searchString = "&tags=\(tags)"
        
        let requestURL = NSURL(string: baseURL + apiString + searchString)
        let request = NSURLRequest(URL: requestURL!)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if error != nil {
                completion(photoUrl: nil, error: error)
            } else {
                let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! [NSDictionary]
        
                let photos = FlickrPhoto.getPhotosFromArray(json)
                let owner = photos.first?.owner
                let photoId = photos.first?.id
                let firstPhotoUrl = "https://www.flickr.com/photos/\(owner)/\(photoId)/"
                print(firstPhotoUrl)
                completion(photoUrl: firstPhotoUrl, error: nil)
                
            }
        }
        
        task.resume()
    }
}