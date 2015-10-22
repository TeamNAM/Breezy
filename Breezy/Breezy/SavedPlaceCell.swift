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
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    
    var place: Place? {
        didSet {
            if let place = self.place {
                self.addressLabel.text = place.addressDescription
            } else  {
                self.addressLabel.text = ""
            }

        }
    }
    var placeType: PlaceType? {
        didSet {
            if let placeType = self.placeType {
                var iconName: String
                switch placeType {
                case .Home:
                    iconName = "home"
                case .Work:
                    iconName = "briefcase"
                default:
                    iconName = "pin"
                }
                self.iconImageView.image = UIImage(named: iconName)
            }
        }
    }
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
