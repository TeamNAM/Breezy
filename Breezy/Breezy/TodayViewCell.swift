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
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var suggestionsStackView: UIStackView!
    @IBOutlet weak var suggestionsStackViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    
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
            switch placeType {
            case .Home:
                return "Home"
            case .Work:
                return "Work"
            case .Other:
                return place.name
            }
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
        
        self.placeNameLabel.text = self.getPlaceNameLabel(placeType, place: self.place)
        
        self.summaryLabel.text = ""
        self.temperatureLabel.text = ""
        self.suggestionsStackView.hidden = true
        
        if let _ = self.place {
            if let forecast = self.forecast {
                self.temperatureLabel.hidden = false
                let currentTemperature = Int(round(forecast.currently!.temperature!))
                self.temperatureLabel.text = "\(currentTemperature)°"
                let dailyForecast = forecast.daily!.data![0]
                self.summaryLabel.text = dailyForecast.summary
                self.renderSuggestionIcons(dailyForecast)
            }
        }

        self.cardView.layer.cornerRadius = 5
        self.contentView.layoutIfNeeded()
    }
    
    func renderSuggestionIcons(dailyForecast: DataPoint) -> Void {
        self.suggestionsStackView.hidden = false
        let suggestions = Set(dailyForecast.getSuggestions())
        
        for subview in self.suggestionsStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        for suggestion in suggestions {
            var image = UIImage(named: suggestion.imageName!)
            image = image?.imageWithRenderingMode(.AlwaysTemplate)
            let imageView = UIImageView(image: image)
            imageView.contentMode = .ScaleAspectFit
            imageView.tintColor = UIColor.whiteColor()
        self.suggestionsStackView.addArrangedSubview(imageView)
        }
        let iconCount = CGFloat(self.suggestionsStackView.arrangedSubviews.count)
        if iconCount > 0 {
            var stackViewWidth = (42.0 * (iconCount - 1.0)) + 24.0
            if stackViewWidth > self.contentView.frame.width {
                stackViewWidth = self.contentView.frame.width - 40.0
            }
            self.suggestionsStackViewWidthConstraint.constant = stackViewWidth
        }
    }
}
