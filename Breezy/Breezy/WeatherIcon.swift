//
//  WeatherIcon.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 11/2/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import Foundation

func getImageForWeatherIcon(iconString: String) -> UIImage?  {
    let iconStringToImgName = [
        "clear-day": "icon-clear-day",
        "clear-night": "icon-clear-night",
        "rain": "icon-rain",
        "snow": "icon-snow",
        "sleet": "icon-sleet",
        "wind": "icon-wind",
        "fog": "icon-fog",
        "cloudy": "icon-cloudy",
        "partly-cloudy-day": "icon-partly-cloudy-day",
        "partly-cloudy-night": "icon-partly-cloudy-night",
    ]
    
    if let imgName = iconStringToImgName[iconString] {
        return UIImage(named: imgName)
    } else {
        return nil
    }
}