//
//  WeatherDayCell.swift
//  Breezy
//
//  Created by Matthew Goo on 10/26/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit

class WeatherDayCell: UITableViewCell {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    var weather: Weather?

    override func awakeFromNib() {
        super.awakeFromNib()
        if let weather = weather {
            
        
            print(weather.temperature)
            temperatureLabel.text = "\(weather.temperature)"
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
