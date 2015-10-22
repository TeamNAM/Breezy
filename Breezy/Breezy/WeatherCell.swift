//
//  WeatherCell.swift
//  Breezy
//
//  Created by Matthew Goo on 10/20/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var placeTypeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var boldMessageLabel: UILabel!
    @IBOutlet weak var detailMessageLabel: UILabel!
    
    var place: Place? {
        didSet {
            placeTypeLabel.text = place!.placeType!.rawValue
            iconImageView.image = place!.recommendationIcon
            boldMessageLabel.text = place!.recommendationMessage
            detailMessageLabel.text = place!.detailedMessage
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
