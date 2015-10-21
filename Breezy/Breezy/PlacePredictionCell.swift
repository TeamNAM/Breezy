//
//  PlacePredictionCell.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 10/18/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit
import GoogleMaps

class PlacePredictionCell: UITableViewCell {
  // MARK: Properties
  
  static let reuseIdentifier = "PlacePredictionCell"
  
  @IBOutlet weak var predictionLabel: UILabel!
  
  var prediction: GMSAutocompletePrediction! {
    didSet {
      let regularFont = UIFont.systemFontOfSize(UIFont.labelFontSize())
      let boldFont = UIFont.boldSystemFontOfSize(UIFont.labelFontSize())
      let bolded = self.prediction.attributedFullText.mutableCopy() as! NSMutableAttributedString
      bolded.enumerateAttribute(kGMSAutocompleteMatchAttribute, inRange: NSMakeRange(0, bolded.length), options: []) { (value, range: NSRange, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
        let font = (value == nil) ? regularFont : boldFont
        bolded.addAttribute(NSFontAttributeName, value: font, range: range)
      }
      self.predictionLabel.attributedText = bolded
    }
  }
  
  // MARK: View Life Cycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
