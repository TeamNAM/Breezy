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
    @IBOutlet weak var iconImageView: UIImageView!
    
    var forecast: Forecast! {
        didSet {
            if let daily = forecast.daily {
                if let data = daily.data {
                    if let weather = data.first {
                        let time: Double = Double(weather.time)
                        let date = NSDate(timeIntervalSince1970: time)

                        datesLabel.text = getMonthAndDay(date)
                        if let temp = weather.temperature {
                            temperatureLabel.text = "\(Int(temp))"
                        }
                    }
                }
            }
        }
    }
    func getMonthAndDay(date: NSDate) -> String {
        let flags: NSCalendarUnit = [NSCalendarUnit.Month, NSCalendarUnit.Day]
        let components = NSCalendar.currentCalendar().components(flags, fromDate: date)
        return "\(components.month)/\(components.day)"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
