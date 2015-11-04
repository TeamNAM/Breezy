//
//  DayWeatherCell.swift
//  Breezy
//
//  Created by Matthew Goo on 10/29/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit
import ForecastIOClient

class DayWeatherCell: UITableViewCell {
    
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    var forecast: Forecast! {
        didSet {
            if let daily = forecast.daily {
                if let data = daily.data {
                    temperatureLabel.text = "\(Int(data.first!.getAverageDailyTemp()))"
                    if let weather = data.first {
                        let time: Double = Double(weather.time)
                        let date = NSDate(timeIntervalSince1970: time)
                        datesLabel.text = getMonthAndDay(date)
                        
                        var img = getImageForWeatherIcon(weather.icon!)
                        img = img?.imageWithRenderingMode(.AlwaysTemplate)
                        print(weather.icon)
                        weatherIconImageView.image = img
                        weatherIconImageView.contentMode = .ScaleAspectFit
                        weatherIconImageView.tintColor = UIColor.whiteColor()
                        
                    }
                }
            }
        }
    }
    func getMonthAndDay(date: NSDate) -> String {
        let flags: NSCalendarUnit = [NSCalendarUnit.Month, NSCalendarUnit.Day]
        let components = NSCalendar.currentCalendar().components(flags, fromDate: date)
        return "\(components.month)/\(components.day+1)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
