//
//  SuggestionCell.swift
//  Breezy
//
//  Created by Matthew Goo on 10/29/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit

class SuggestionCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var suggestion: Suggestion! {
        didSet {
            messageLabel.text = suggestion.message!
            iconImageView.image = UIImage(named: suggestion.imageName!)
            iconImageView.contentMode = .ScaleAspectFit
            iconImageView.tintColor = UIColor.whiteColor()
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
