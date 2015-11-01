//
//  TripCell.swift
//  Breezy
//
//  Created by Matthew Goo on 10/16/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit

class TripCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var trip: Trip! {
        didSet {
            
            nameLabel.text = trip.place!.name
            if let sDate = trip.startDateString {
                if let eDate = trip.endDateString {
                    dateLabel.text = "\(sDate) - \(eDate)"
                }
            }
        }
    }

}

