//
//  SavedPlaceCell.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 10/20/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit

class SavedPlaceCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "SavedPlaceCell"
    
    @IBOutlet weak var addressLabel: UILabel!
    
    var place: Place! {
        didSet {
            self.addressLabel.text = self.place.addressDescription
        }
    }
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
