//
//  HourlyWeatherCell.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 11/2/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import ForecastIOClient
import UIKit

class HourlyWeatherCell: UITableViewCell {
    
    static let reuseIdentifier = "HourlyWeatherCell"
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var hourlyTempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    var hourlyDataPoint: DataPoint?
    var timezoneString: String?
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        // Hour text
        guard let tzString = self.timezoneString else { return }
        guard let timezone = NSTimeZone(name: tzString) else { return }
        guard let dataPoint = self.hourlyDataPoint else { return }
    
        // Time label
        let date = NSDate(timeIntervalSince1970: Double(dataPoint.time))
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.componentsInTimeZone(timezone, fromDate: date)
        let dayPeriod = dateComponents.hour < 12 ? "AM" : "PM"
        var hourNumber: Int
        if dateComponents.hour == 0 {
            hourNumber = 12
        } else if dateComponents.hour < 13 {
            hourNumber = dateComponents.hour
        } else {
            hourNumber = dateComponents.hour - 12
        }
        self.hourLabel.text = "\(hourNumber)\(dayPeriod)"
        
        // Temperature
        self.hourlyTempLabel.text = "\(Temperature(fromValue: dataPoint.temperature!))"
        
        var img = getImageForWeatherIcon(dataPoint.icon!)
        img = img?.imageWithRenderingMode(.AlwaysTemplate)
        self.weatherImageView.image = img
        self.weatherImageView.contentMode = .ScaleAspectFit
        self.weatherImageView.tintColor = UIColor.whiteColor()
   }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
