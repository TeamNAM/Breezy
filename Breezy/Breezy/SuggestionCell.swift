//
//  SuggestionCell.swift
//  Breezy
//
//  Created by Matthew Goo on 10/29/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit

class SuggestionCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIView!
    @IBOutlet weak var messageLabel: UIView!
    var suggestion: Suggestion! {
        didSet {

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
