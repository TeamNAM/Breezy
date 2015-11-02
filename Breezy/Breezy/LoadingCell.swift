//
//  LoadingCell.swift
//  Breezy
//
//  Created by Matthew Goo on 10/31/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {


    @IBOutlet weak var spinnerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        //let spinnerGif = UIImage.gifWithName("spinner")
       // spinnerImageView.image = spinnerGif
    }


}
