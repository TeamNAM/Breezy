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
        return suggestions
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
    case 0..<40:
        return "freezing"
    case 40..<60:
        return "cold"
    case 60..<65:
        return "chilly"
    case 80..<85:
        return "warm"
    case 85...200:
        return "hot"
    default:
        return nil
    }
}