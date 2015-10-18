//
//  Credentials.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 10/15/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import Foundation

struct Credentials {
  static let fileName = "Credentials"
  static let defaultCredentials = Credentials.loadFromPropertyListNamed(fileName)
  
  let forecastKey: String
  let googleKey: String
  
  private static func loadFromPropertyListNamed(name: String) -> Credentials {
    let path = NSBundle.mainBundle().pathForResource(name, ofType: "plist")!
    let dictionary = NSDictionary(contentsOfFile: path)!
    let forecastKey = dictionary["ForecastApiKey"] as! String
    let googleKey = dictionary["GoogleApiKey"] as! String
    return Credentials(forecastKey: forecastKey, googleKey: googleKey)
  }
}