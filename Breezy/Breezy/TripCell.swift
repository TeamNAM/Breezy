//
//  TripCell.swift
//  Breezy
//
//  Created by Matthew Goo on 10/16/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit
import ForecastIOClient

class TripCell: UITableViewCell {
    
    @IBOutlet weak var stackViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var suggestionStackView: UIStackView!
    
    var trip: Trip! {
        didSet {
            nameLabel.textColor = UIColor.whiteColor()
            dateLabel.textColor = UIColor.whiteColor()
            
            nameLabel.text = trip.place!.name
            if let sDate = trip.startDateString {
                if let eDate = trip.endDateString {
                    dateLabel.text = "\(sDate) - \(eDate)"
                }
            }
//            var suggestions = [Suggestion]()
            let dates = trip.dateRange
            if let dates = dates {
                for date in dates {
                    if let daily = trip.forecast[date]?.daily {
                        if let points = daily.data {
                            let dataPoint = points.first
                            self.renderSuggestionIcons(dataPoint!)
                        }
                    }
                }
            }
        }
    }
    
    
    func renderSuggestionIcons(forecast: DataPoint) -> Void {
        self.suggestionStackView.hidden = false
        let suggestions = Set(forecast.getSuggestions())
        
        for subview in self.suggestionStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        for suggestion in suggestions {
            var image = UIImage(named: suggestion.imageName!)
            image = image?.imageWithRenderingMode(.AlwaysTemplate)
            let imageView = UIImageView(image: image)
            imageView.contentMode = .ScaleAspectFit
            imageView.tintColor = UIColor.whiteColor()
            self.suggestionStackView.addArrangedSubview(imageView)
        }
        let iconCount = CGFloat(self.suggestionStackView.arrangedSubviews.count)
        if iconCount > 0 {
            var stackViewWidth = (42.0 * (iconCount - 1.0)) + 24.0
            if stackViewWidth > self.contentView.frame.width {
                stackViewWidth = self.contentView.frame.width - 40.0
            }
            self.stackViewWidthConstraint.constant = stackViewWidth
        }
    }

}

