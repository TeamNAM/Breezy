//
//  TodayViewCell.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 10/22/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit

class TodayViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TodayViewCell"

    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeImageView: UIImageView!
    
    var data = Dictionary<String, Any?>() {
        didSet {
            self.placeType = self.data["placeType"] as! PlaceType
            self.place = self.data["place"] as? Place
            let imageName = self.getPlaceImageViewName(self.placeType)
            self.placeImageView.image = UIImage(named: imageName)
            self.placeNameLabel.text = self.getPlaceNameLabel(self.placeType, place: self.place)
        }
    }
    var placeType: PlaceType!
    var place: Place?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("calling awake from nib")
    }
    
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
    
}
