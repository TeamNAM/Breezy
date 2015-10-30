//
//  WeatherDayCell.swift
//  Breezy
//
//  Created by Matthew Goo on 10/26/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit
import ForecastIOClient

class WeatherDayCell: UITableViewCell {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    var forecast: Forecast?

    override func awakeFromNib() {
        super.awakeFromNib()
        if let forecast = forecast {
            
        
//            print(forecast.temperature)
//            temperatureLabel.text = "\(forecast.temperature)"
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
