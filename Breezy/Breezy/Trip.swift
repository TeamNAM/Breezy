//
//  Trip.swift
//  Breezy
//
//  Created by Anvisha Pai on 10/21/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import Foundation
import ForecastIOClient

let START_KEY = "startDate"
let END_KEY = "endDate"
let PLACE_KEY = "place"

class Trip : NSObject, NSCoding {
    var startDate: NSDate?
    var endDate: NSDate?
    var place: Place?
    var startDateString: String?
    var endDateString: String?
    var dateRange: [NSDate]?
    var suggestions: [Suggestion]?
    var averageTemp: Double?
    var forecast = Dictionary<NSDate, Forecast>()
    var hasLoadedForecast = false
    
    let dateFormatter = NSDateFormatter()
    
    init(startDate: NSDate, endDate: NSDate, place: Place, name: String?){
        super.init()
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        self.startDate = startDate
        self.endDate = endDate
        self.place = place
        if let name = name {
            place.name = name
        }
        
        self.dateRange = getDateRange(startDate, endDate: endDate)

        self.setupDateStrings()
    }
    
    func setupDateStrings() {
        if getYear(startDate!) == getYear(endDate!) {
            dateFormatter.dateFormat = "MMM d"
        } else {
            dateFormatter.dateFormat = "MMM d yy"
        }
        self.startDateString = dateFormatter.stringFromDate(startDate!)
        self.endDateString = dateFormatter.stringFromDate(endDate!)
    }
    
    func getYear(date: NSDate) -> Int {
        let flags = NSCalendarUnit.Year
        let components = NSCalendar.currentCalendar().components(flags, fromDate: date)
        
        return components.year
    }
    
    func loadForecast(completion: (() -> ())? = nil) {
        if startDate != nil && endDate != nil && place != nil {
            let place = self.place
            let httpRequestGroup = dispatch_group_create()
            
            for date in self.dateRange! {
                dispatch_group_enter(httpRequestGroup)
                ForecastIOClient.sharedInstance.forecast(place!.lat, longitude: place!.lng, time: date, extendHourly: true, exclude: [ForecastBlocks.Currently, ForecastBlocks.Minutely], failure: { (error) -> Void in
                    print(error)
                    }) { (forecast, forecastAPICalls) -> Void in
                        self.forecast[date] = forecast
                        dispatch_group_leave(httpRequestGroup)
                }
            }
            
            dispatch_group_notify(httpRequestGroup, dispatch_get_main_queue()) {
                print("start: \(self.startDateString) end: \(self.endDateString)")
                self.setAverageTemp()
                self.setSuggestions()
                self.hasLoadedForecast = true
                completion?()
            }
        } else {
            print("this is not a complete trip")
        }
    }
    
    private func setAverageTemp() {
        let dataPoints = getDataPoints()
        var totalTemp:Double = 0.0
        var totalCount = 0
        for point in dataPoints {
            if let temp = point.temperature {
                totalTemp += temp
                ++totalCount
            } else {
                if let minTemp = point.temperatureMin {
                    if let maxTemp = point.temperatureMax {
                        let avgTemp = (minTemp + maxTemp)/Double(2)
                        totalTemp += avgTemp
                    }
                }
                ++totalCount
            }
        }
        self.averageTemp = totalTemp/Double(totalCount)
    }
    
    func setSuggestions() {
        let dataPoints = getDataPoints()
        self.suggestions = suggestionsForDataPoints(dataPoints)
    }
    
    func getDataPoints() -> [DataPoint] {
        var dataPoints = [DataPoint]()
        for date in self.dateRange! {
            let dataPoint = self.forecast[date]?.daily?.data?.first
            if let dp = dataPoint {
                dataPoints.append(dp)
            }
        }
        return dataPoints
    }
    
    private func getDateRange(startDate: NSDate, endDate: NSDate) -> [NSDate] {
        let cal = NSCalendar.currentCalendar()
        
        let components = cal.components(NSCalendarUnit.Day, fromDate: startDate, toDate: endDate, options: NSCalendarOptions.MatchStrictly)
        
        var dates = [NSDate]()
        for var i=0; i<components.day; i++ {
            let unixDay:NSTimeInterval = Double(86400*i)
            let date = NSDate(timeInterval: unixDay, sinceDate: startDate)
            dates.append(date)
        }
        
        return dates
    }
    
    required init?(coder aDecoder: NSCoder){
        self.startDate = aDecoder.decodeObjectForKey(START_KEY) as? NSDate
        self.endDate = aDecoder.decodeObjectForKey(END_KEY) as? NSDate
        self.place = aDecoder.decodeObjectForKey(PLACE_KEY) as? Place
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.startDate, forKey: START_KEY)
        aCoder.encodeObject(self.endDate, forKey: END_KEY)
        aCoder.encodeObject(self.place, forKey: PLACE_KEY)
    }
    
}