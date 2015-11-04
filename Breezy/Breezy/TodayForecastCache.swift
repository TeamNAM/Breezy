//
//  TodayForecastCache.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 10/28/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import ForecastIOClient
import UIKit

class TodayForecastCache {
 
    private init() {}
    
    // A map from `place.uuid` to `Forecast`
    static private var cache = [String: Forecast]()
    static private var currentLocationForecast: Forecast? = nil
    
    static func forecastForPlace(place: Place) -> Forecast? {
        return self.cache[place.uuid]
    }

    static func forecastForCurrentLocation() -> Forecast? {
        return self.currentLocationForecast
    }
    
    static func fetchForecastForPlace(place: Place, completion: ((Forecast) -> Void)?) {
        // Only fetch weather if it's been longer than 5 minutes
        let now = NSDate().timeIntervalSince1970
        if let cachedForecast = self.cache[place.uuid] where now - Double(cachedForecast.currently!.time) < (60.0 * 5) {
//            print("Loaded cached weather info for \(place.name)")
            completion?(cachedForecast)
        } else  {
            ForecastIOClient.sharedInstance.forecast(place.lat, longitude: place.lng) { (forecast: Forecast, forecastAPICalls) -> Void in
//                print("\(1000 - forecastAPICalls!) Forecast API calls left today")
//                print("Fetched weather info for \(place.name)")
                self.cache[place.uuid] = forecast
                completion?(forecast)
            }
        }
    }
    
    static func fetchForecastForCurrentLocation(location: CLLocation, completion: ((Forecast) -> Void)?) {
        // Only fetch weather if it's been longer than 5 seconds
        let now = NSDate().timeIntervalSince1970
        if let cachedForecast = self.currentLocationForecast where now - Double(cachedForecast.currently!.time) < 30.0 {
            //            print("Loaded cached weather info for \(place.name)")
            completion?(cachedForecast)
        } else  {
            ForecastIOClient.sharedInstance.forecast(location.coordinate.latitude, longitude: location.coordinate.longitude) { (forecast: Forecast, forecastAPICalls) -> Void in
                //                print("\(1000 - forecastAPICalls!) Forecast API calls left today")
                //                print("Fetched weather info for \(place.name)")
                self.currentLocationForecast = forecast
                completion?(forecast)
            }
        }
    }
}
