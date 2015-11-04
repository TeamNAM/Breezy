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
    
    var suggestion: Suggestion!
    
    override func layoutSubviews() {
        var image = UIImage(named: suggestion.imageName!)
        image = image?.imageWithRenderingMode(.AlwaysTemplate)
//        let imageView = UIImageView(image: image)
        iconImageView.image = image
        iconImageView.contentMode = .ScaleAspectFit
        iconImageView.tintColor = UIColor.whiteColor()
        messageLabel.text = suggestion.description
    }
    

}
