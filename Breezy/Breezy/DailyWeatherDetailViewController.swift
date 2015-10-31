//
//  DailyWeatherDetailViewController.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 10/27/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import ImageEffects
import ForecastIOClient
import UIKit

// TODO(nikrad): move this into the model directory
struct Temperature: CustomStringConvertible {
    let value: Double
    
    init(fromValue: Double) {
        self.value = fromValue
    }
    
    var description: String {
        let roundedTemp = Int(round(self.value))
        return "\(roundedTemp)°"
    }
}

struct PrecipitationChance: CustomStringConvertible {
    let value: Double
    
    init(fromValue: Double) {
        self.value = fromValue
    }
    
    var description: String {
        let percentage = Int(round(self.value * 100))
        return "\(percentage)%"
    }
}

class DailyWeatherDetailViewController: UIViewController {
    
    // MARK: - Static initializer
    
    static func instantiateFromStoryboard() -> DailyWeatherDetailViewController {
        let vc = UIStoryboard(name: storyboardID, bundle: nil).instantiateViewControllerWithIdentifier(storyboardID) as! DailyWeatherDetailViewController
        return vc
    }
    
    // MARK: Static properties

    static let storyboardID = "DailyWeatherDetailViewController"
    
    // MARK: Properties

    @IBOutlet weak var placeLabel: UILabel!
    var place: Place?
    var forecast: Forecast?
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var precipChanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let place = self.place {
            self.placeLabel.text = place.name
        }
        if let forecast = self.forecast {
            let currentForecast = forecast.currently!
            
            let bgRect = self.view.bounds
            let backgroundView = UIView(frame: bgRect)
            let imgView = UIImageView(frame: backgroundView.bounds)
            var img = currentForecast.getBackground()
            imgView.image = img.blurredImageWithRadius(50.0)
            imgView.contentMode = .ScaleAspectFill
            backgroundView.addSubview(imgView)
            let fillColorView = UIView(frame: bgRect)
            let temperature = currentForecast.temperature as Double!
            fillColorView.backgroundColor = ColorPalette.getAverageColorForTemp(temperature)
            fillColorView.alpha = 0.5
            backgroundView.addSubview(fillColorView)
            
            self.view.addSubview(backgroundView)
            self.view.sendSubviewToBack(backgroundView)
            
            
            self.currentTempLabel.text = String(Temperature(fromValue: (forecast.currently?.temperature)!))
            let dailyWeather = forecast.daily?.data?[0] as DataPoint!
            self.summaryLabel.text = dailyWeather.summary as String!
            self.maxTempLabel.text = String(Temperature(fromValue: dailyWeather.temperatureMax!))
            self.minTempLabel.text = String(Temperature(fromValue: dailyWeather.temperatureMin!))
            self.precipChanceLabel.text = String(PrecipitationChance(fromValue: dailyWeather.precipProbability!))
        }
    }

}
