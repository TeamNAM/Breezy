//
//  DailyWeatherSuggestionCell.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 11/2/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit

class DailyWeatherSuggestionCell: UITableViewCell {
    
    static let reuseIdentifier = "DailyWeatherSuggestionCell"

    @IBOutlet weak var suggestionMessageLabel: UILabel!
    @IBOutlet weak var suggestionImageView: UIImageView!
    
    var suggestion: Suggestion? {
        didSet {
            if let suggestion = self.suggestion {
                self.suggestionMessageLabel.text = suggestion.message
                
                var img = UIImage(named: suggestion.imageName!)
                img = img?.imageWithRenderingMode(.AlwaysTemplate)
                suggestionImageView.image = img
                suggestionImageView.contentMode = .ScaleAspectFit
                suggestionImageView.tintColor = UIColor.whiteColor()
            }
        }
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
