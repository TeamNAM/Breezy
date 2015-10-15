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
  static let apiKey = Credentials.loadApiKeyFromPropertyListNamed(fileName)
  
  private static func loadApiKeyFromPropertyListNamed(name: String) -> String {
    let path = NSBundle.mainBundle().pathForResource(name, ofType: "plist")!
    let dictionary = NSDictionary(contentsOfFile: path)!
    return dictionary["ApiKey"] as! String
  }
}