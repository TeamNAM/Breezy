//
//  TodayViewCell.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 10/22/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import ForecastIOClient
import UIKit

class TodayViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TodayViewCell"

    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var suggestionsStackView: UIStackView!
    @IBOutlet weak var suggestionsStackViewWidthConstraint: NSLayoutConstraint!
    
    var placeType: PlaceType?
    var place: Place?
    var forecast: Forecast?
    
    func getPlaceImageViewName(placeType: PlaceType) -> String {
        switch placeType {
        case .Home:
            return "home"
        case .Work:
            return "briefcase"
        case .Other:
            return "pin"
        }
    }
    
    func getPlaceNameLabel(placeType: PlaceType, place: Place?) -> String {
        if let place = place {
            return place.name
        } else {
            switch placeType {
            case .Home:
                return "Add home address"
            case .Work:
                return "Add work address"
            case .Other:
                assert(false, "TodayViewCell received PlaceType.Other when place is nil.")
            }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let placeType = self.placeType else {
            assert(false, "Missing place type")
        }
        
        let imageName = self.getPlaceImageViewName(placeType)
        self.placeImageView.image = UIImage(named: imageName)
        self.placeNameLabel.text = self.getPlaceNameLabel(placeType, place: self.place)
        
        if let place = self.place {
            if let forecast = self.forecast {
                self.temperatureLabel.hidden = false
                let currentTemperature = Int(round(forecast.currently!.temperature!))
                self.temperatureLabel.text = "\(currentTemperature)°"
                let dailyForecast = forecast.daily!.data![0]
                self.renderSuggestionIcons(dailyForecast)
            } else {
                self.temperatureLabel.text = "--°"
            }
        } else  {
            self.temperatureLabel.hidden = true
        }
        
        self.contentView.layoutIfNeeded()
    }
    
    func renderSuggestionIcons(dailyForecast: DataPoint) -> Void {
        let suggestions = Set(dailyForecast.getSuggestions())
        
        for subview in self.suggestionsStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        for suggestion in suggestions {
            let image = UIImage(named: suggestion.imageName!)
            let imageView = UIImageView(image: image)
            imageView.contentMode = .Center
            self.suggestionsStackView.addArrangedSubview(imageView)
        }
        let iconCount = CGFloat(self.suggestionsStackView.arrangedSubviews.count)
        if iconCount > 0 {
            var stackViewWidth = (50.0 * (iconCount - 1.0)) + 32.0
            if stackViewWidth > self.contentView.frame.width {
                stackViewWidth = self.contentView.frame.width - 40.0
            }
            self.suggestionsStackViewWidthConstraint.constant = stackViewWidth
        }
    }
}
