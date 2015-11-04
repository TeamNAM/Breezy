//
//  ForecastIOClient.swift
//  Breezy
//
//  Created by Anvisha Pai on 10/28/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import Foundation
import ForecastIOClient

extension DataPoint {
    func getBackground() -> UIImage {
        if let precip = self.precipType {
            switch precip {
            case .Rain:
                return UIImage(named: "rainbg")!
            default:
                return UIImage(named: "snowbg")!
            }
        }
            
        if let cloudCoverWarning = getCloudCoverWarning(self.cloudCover!) {
            if cloudCoverWarning == "overcast" {
                return  UIImage(named: "cloudbg")!
            }
        }
        
        return  UIImage(named: "sunbg")!

    }
    
    func getSuggestions() -> [Suggestion] {
        let dataPoint = self
        var suggestions = [Suggestion]()
        //Temperature
        if let minTemp = dataPoint.temperatureMin {
            if let warning = getTemperatureWarning(minTemp) {
                suggestions.append(Suggestion(name: warning))
            }
            if let warning = getTemperatureWarning(dataPoint.temperatureMax!) {
                suggestions.append(Suggestion(name: warning))
            }
        } else {
            if let warning = getTemperatureWarning(dataPoint.temperature!){
                suggestions.append(Suggestion(name: warning))
            }
        }
        
        //Precip
        if let precip = dataPoint.precipType {
            switch precip {
            case .Rain:
                suggestions.append(Suggestion(name: "rain"))
            case .Hail:
                suggestions.append(Suggestion(name: "hail"))
            case .Sleet:
                suggestions.append(Suggestion(name: "sleet"))
            case .Snow:
                suggestions.append(Suggestion(name: "snow"))
            }
        }
        
        //cloud cover
        if let cloudCover = cloudCover {
            if let cloudCoverWarning = getCloudCoverWarning(cloudCover) {
                suggestions.append(Suggestion(name: cloudCoverWarning))
            }
        }
        
        return suggestions
    }
    
    func getAverageDailyTemp() -> Double {
        let totalTemp = self.temperatureMax! + self.temperatureMin!
        return totalTemp/2
    }
}

//Put in an array of data points of hourly data.
func suggestionsForDataPoints(dataPoints: [DataPoint]) -> [Suggestion] {
    var suggestions = [Suggestion]()
    for dataPoint in dataPoints {
        let sugg = dataPoint.getSuggestions()
        for s in sugg {
            if  suggestions.filter({ el in el.name == s.name}).count > 0{
                //do nothing
            } else {
                suggestions.append(s)
            }
        }
    }
    return suggestions
}

func getTemperatureWarning(temp: Double) -> (String?) {
    switch temp {
    case 0..<32:
        return "freezing"
    case 32..<50:
        return "cold"
    case 50..<60:
        return "chilly"
    case 80..<85:
        return "warm"
    case 85...200:
        return "hot"
    default:
        return nil
    }
}
//
//cloudCover: A numerical value between 0 and 1 (inclusive) representing the percentage of sky occluded by clouds. A value of 0 corresponds to clear sky, 0.4 to scattered clouds, 0.75 to broken cloud cover, and 1 to completely overcast skies.

func getCloudCoverWarning(cloudCover: Double) -> (String?) {
//    print(cloudCover)
    switch cloudCover {
    case 0..<0.2:
        return "clear"
//    case 0.2..<0.75:
//        return "scattered_clouds"
    case 0.75..<1:
        return "overcast"
    default:
        return nil
    }
}